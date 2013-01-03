class Tenant
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::History::Trackable
  include Mongoid::History::Snapshot

  field :name, :type => String
  validates :name, :presence => true

  field :is_anchor, :type => Boolean, :default => false
  validates :is_anchor, inclusion: { :in => [true, false] }

  embedded_in :shopping_center, :inverse_of => :tenants

  track_history :on => [:name, :is_anchor],
    :scope => :shopping_center,
    :modified_field => :modifier,
    :version_field => :version,
    :track_create => true,
    :track_update => true,
    :track_destroy => true

  def anchor?
    self.is_anchor
  end
end
