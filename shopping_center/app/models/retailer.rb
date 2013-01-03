class Retailer
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::History::Trackable
  include Mongoid::History::Snapshot
  include Mongoid::FullTextSearch

  field :name, :type => String
  validates :name, :presence => true

  field :primary_sector, :type => String
  validates :primary_sector, :presence => true

  field :sectors, :type => Array

  field :company, :type => String
  validates :company, :presence => true

  field :store_count, :type => Integer

  field :company_website, :type => String
  field :store_locator_url, :type => String
  field :closed, :type => Boolean
  field :should_index, :type => Boolean

  belongs_to :initiated_by, :class_name => "User"

  embeds_many :comments
  embeds_many :collection_instances, :cascade_callbacks => true

  accepts_nested_attributes_for :collection_instances, :reject_if => lambda{ |ci| !ci[:collected_on].nil? && ci[:collected_on].blank? }, :allow_destroy => true

  track_history :on => :all,
                :modified_field => :modifier,
                :version_field => :version,
                :track_create => true,
                :track_update => true,
                :track_destroy => true

  def keywords
    ret = Array.new
    ret << self.name
    ret << self.primary_sector
    ret.concat( self.sectors || [] )
    ret << self.company

    @keywords = ret.flatten.join(' ')
  end
  fulltext_search_in :keywords

  def self.collected_by *users
    any_in("collection_instances.collector_id" => users.collect(&:id))
  end

  def self.initiated_by *users
    any_in(initiated_by_id: users.collect(&:id))
  end
end
