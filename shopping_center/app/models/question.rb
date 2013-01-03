class Question
  include Mongoid::Document
  include Mongoid::Timestamps

  field :question, type: String
  field :answer, type: String
  validates :answer, :question, presence: true
end
