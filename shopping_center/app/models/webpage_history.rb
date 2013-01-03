class WebpageHistory
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::History::Trackable
  include Mongoid::History::Snapshot

  field :url, :type => String, :null => false
  field :body, :type => String, :null => false

  validates_presence_of :url, :body

  track_history :on => :all,
    :modified_field => :modifier,
    :version_field => :version,
    :track_create => true,
    :track_update => true,
    :track_destroy => true
end
