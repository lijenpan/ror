class EquityOwner
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::History::Trackable
  include Mongoid::History::Snapshot

  field :name, :type => String
  field :ownership, :type => Float
  validates :name, :presence => true
  validates :ownership, :numericality => { :greater_than_or_equal_to => 0.0, :less_than_or_equal_to => 100.0 }, :allow_nil => true

  embedded_in :shopping_center

  track_history :on => :all,
    :scope => :shopping_center,
    :modified_field => :modifier,
    :version_field => :version,
    :track_create => true,
    :track_update => true,
    :track_destroy => true
end
