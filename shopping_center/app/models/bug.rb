class Bug
  include Mongoid::Document
  include Mongoid::Timestamps

  field :submitted_by, type: String
  field :email, type: String
  field :subject, type: String
  field :url, type: String
  field :severity, type: Integer
  field :description, type: String
  validates :submitted_by, :email, :subject, :url, :severity, :description, :presence => true

  def self.severity_options
    [["Critial", 0],["High", 1],["Moderate", 2],["Low", 3]]
  end
end
