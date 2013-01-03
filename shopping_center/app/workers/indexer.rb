require 'mechanize'
require 'uri'

class Indexer
  extend HTMLDiff
  extend HerokuAutoScaler::AutoScaling

  @queue = :file_server

  def self.perform
    Retailer.all.each do |r|
      if !r.store_locator_url.blank?
        if WebpageHistory.where(:url => r.store_locator_url).count > 0
          get_diff(r.store_locator_url)
        else
          body = scrape(r.store_locator_url)
          #we only want to store the html body rather than the enntire response
          #because that's the only thing we care about.
          WebpageHistory.create(:url => r.store_locator_url, :body => body)
        end
      end
    end
  end

  private
  def self.get_diff(url)
    new = scrape(url)
    old = WebpageHistory.where(:url => url).first.body
    diff = Indexer.diff(old, new)

    if diff.include? '</ins>' or diff.include? '</del>'
      #save live page if there is change
      file_name = "#{DateTime.now.strftime("%Y.%m.%d")}_#{URI.parse(url).host}.html"
      File.open("tmp/#{file_name}", 'w') do |f|
        f.write("<html><head><style type='text/css'>")
        f.write("del.diffmod{color:#999;background-color:#efefef;}")
        f.write("ins.diffmod{color:#000;background-color:#cfc;text-decoration:none;}")
        f.write('</style></head>')
        f.write(diff)
        f.write('</html>')
      end
      puts "[#{DateTime.now.strftime("%Y-%m-%d %H:%M:%S")}] Upload #{file_name} to s3"
      key, s3_url = AWSUtil.send("website_index", "tmp/#{file_name}")

      #find whom should the index change task assign to.
      #it should be assign to the same researcher covers the company.
      assignee = nil
      CoverageList.all.each do |cl|
        cl.policies.each do |cp|
          assignee = cl.assignee if cp.retailer.store_locator_url.include? key[11, key.length-16]
          break if !assignee.nil?
        end
        #we take the first researcher covers the company.
        #we assume there are no multiple researchers cover the same company.
        break if !assignee.nil?
      end

      if Task.create!(:title => key, :description => s3_url, :creator => User.where(:email => "apan@pps.com").first, :assignee => assignee, :due_date => DateTime.now)
        puts "[#{DateTime.now.strftime("%Y-%m-%d %H:%M:%S")}] Task is created!"
      else
        puts "[#{DateTime.now.strftime("%Y-%m-%d %H:%M:%S")}] Creating task failed!"
      end
      WebpageHistory.where(:url => url).first.update_attributes(:body => new)
    else
      puts 'Nothing is changed. Hooray!'
    end
  end

  def self.scrape(url)
    agent = Mechanize.new do |browser|
      browser.user_agent_alias = 'Linux Firefox'
    end
    page = agent.get(url)
    #keep the tags but strip off their attributes
    Sanitize.clean(page.parser.xpath('//body').to_html,
                   :elements => whitelist,
                   :remove_contents => blacklist)
  end

  def self.whitelist
    #HTML5 tags, exclude area, audio, canvas, img, map, noscript, object, source, video
    ['a','abbr','address','article','aside','b','base','bdi','bdo','blockquote','body','br','button','caption','cite','code','col','colgroup','command',
    'datalist','dd','del','details','dfn','div','dl','dt','em','embed','fieldset','figcaption','figure','footer','form','h1','h2','h3','h4','h5','h6',
    'header','hgroup','hr','i','iframe','input','ins','keygen','kbd','label','legend','li','mark','menu','meter','nav','ol','optgroup','option','output',
    'p','param','pre','progress','q','rp','rt','ruby','s','samp','section','small','span','strong','sub','summary','sup','table','tbody','td','textarea',
    'tfoot','th','thead','time','tr','u','ul','wbr']
  end

  def self.blacklist
    ['script','style']
  end
end
