class ShoppingCenter
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::History::Trackable
  include Mongoid::History::Snapshot
  include Mongoid::FullTextSearch
  include ShoppingCenterStateMachine
  include TotalEquityOwnershipValidator

  belongs_to :researcher
  belongs_to :research_manager

  field :name, :type => String
  validates :name, :presence => true

  field :url, :type => String

  embeds_one :address, :cascade_callbacks => true
  embeds_many :tenants, :cascade_callbacks => true
  embeds_many :comments, :as => :commentable
  embeds_many :assets, :cascade_callbacks => true

  embeds_many :equity_owners, :cascade_callbacks => true
  validate_total_ownership

  snapshotable :address, :equity_owners, :tenants

  accepts_nested_attributes_for :address, :allow_destroy => true
  accepts_nested_attributes_for :tenants, :allow_destroy => true
  accepts_nested_attributes_for :equity_owners, :reject_if => lambda { |eo| eo[:name].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :assets, :allow_destroy => true

  track_history :on => :all,
                :modified_field => :modifier,
                :version_field => :version,
                :track_create => true,
                :track_update => true,
                :track_destroy => true

  def has_tenant?(tenant_name)
    !self.tenants.where(name: tenant_name).empty?
  end

  def anchor_tenants
    tenants.where(is_anchor: true)
  end

  def keywords
    ret = Array.new

    ret << self.name

    unless self.address.nil?
      ret << self.address.municipality
      ret << self.address.governing_district
      ret << self.address.postal_code
    end

    ret << self.tenants.collect(&:name)
    ret << self.equity_owners.collect(&:name)
    # ret << self.researcher.name unless self.researcher.nil?
    # ret << self.research_manager.name unless self.research_manager.nil?
    @keywords = ret.flatten.join(' ')
  end

  # fulltext_search_in :keywords,
  #                    :filters => { :searchable => lambda { |x| x.state == 'searchable' } }
  fulltext_search_in :name, :index_name => 'shopping_center_name_index'
  fulltext_search_in :keywords, :index_name => 'shopping_center_full_index'

  def self.event_translator(e)
    e.to_s.gsub('scsm_', '').to_sym
  end

  def self.waiting_on_researcher
    any_in(state: ["awaiting_promotion", "researcher_collecting", "error", "incomplete"])
  end

  def self.waiting_on_research_manager
    any_in(state: ["awaiting_verification", "manager_collecting", "stalled"])
  end

  def self.verified_by *users
    any_in(research_manager_id: users.collect(&:id))
  end

  def self.collected_by *users
    any_in(researcher_id: users.collect(&:id))
  end
end
