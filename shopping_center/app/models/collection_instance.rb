class CollectionInstance
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::History::Trackable
  include Mongoid::History::Snapshot

  field :collected_on, type: DateTime
  validates :collected_on, :presence => true

  field :harvested, type: Boolean, default: false
  validates :harvested, :inclusion => { :in => [true, false] }

  embedded_in :retailer
  belongs_to :collector, class_name: "User"

  def collected_by
    harvested ? 'harvester' : (self.collector.try(:name) || 'unknown user')
  end
end
