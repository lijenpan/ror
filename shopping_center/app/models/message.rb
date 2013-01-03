class Message
  include Mongoid::Document
  include Mongoid::Timestamps

  field :body, type: String
  field :author, type: String
  validates :author, :body, :presence => true
end
