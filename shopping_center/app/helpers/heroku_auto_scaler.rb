require 'heroku'

module HerokuAutoScaler
  module AutoScaling
    def after_perform_scale_down(*args)
      HerokuAutoScaler.scale_down!
    end

    def after_enqueue_scale_up(*args)
      HerokuAutoScaler.scale_up!
    end

    def on_failure(e, *args)
      Rails.logger.info("Resque Exception for [#{self.to_s}, #{args.join(', ')}]: #{e.to_s}")
      HerokuAutoScaler.scale_down!
    end
  end

  extend self

  attr_accessor :ignore_scaling

  def clear_resque
    Resque::Worker.all.each {|w| w.unregister_worker}
  end

  def configure(&block)
    instance_eval(&block) if block_given?
  end

  def scale_by(&block)
    self.scaling_block = block
  end

  def scale_down!
    Rails.logger.info "Scale down j:#{job_count} w:#{resque_workers}"
    self.heroku_workers = 0 if job_count == 0 && resque_workers == 1
  end

  def scale_up!
    return if ignore_scaling
    pending = job_count
    self.heroku_workers = workers_for(pending) if pending > 0
  end

  private
  attr_accessor :scaling_block

  def heroku
    if ENV['HEROKU_USER'] && ENV['HEROKU_PASSWORD'] && ENV['HEROKU_APP']
      @heroku ||= Heroku::Client.new(ENV['HEROKU_USER'], ENV['HEROKU_PASSWORD'])
    else
      false
    end
  end

  def heroku_workers=(qty)
    heroku.set_workers(ENV['HEROKU_APP'], qty) if heroku
  end

  def job_count
    Resque.info[:pending]
  end

  def resque_workers
    Resque.info[:working]
  end

  def workers_for(pending_jobs)
    if scaling_block
      scaling_block.call(pending_jobs)
    else
      [
        {:workers => 1, :job_count => 1},
        {:workers => 2, :job_count => 15},
        {:workers => 3, :job_count => 25},
        {:workers => 4, :job_count => 40},
        {:workers => 5, :job_count => 60}
      ].reverse_each do |scale_info|
        if pending_jobs >= scale_info[:job_count]
          return scale_info[:workers]
        end
      end
    end
  end
end
