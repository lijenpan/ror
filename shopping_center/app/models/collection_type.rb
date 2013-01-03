class CollectionType
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :researchers

  field :name, type: String
  validates :name, presence: true
end
