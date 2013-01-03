class CoverageList
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  ###fields
  field :name, type: String
  field :default_duration, type: Integer, default: 4320 #stored in minutes

  ###associations
  embeds_many :policies, cascade_callbacks: true, class_name: "CoveragePolicy"
  embeds_many :tasks, cascade_callbacks: true, class_name: "CoverageTask"

  belongs_to :assignee, class_name: "Researcher"
  belongs_to :research_group, class_name: "ResearchGroup"

  ###validations
  validates :name, presence: true, allow_nil: false, allow_blank: false
  validates :research_group, presence: true, allow_nil: false

  ###other
  slug :name
end
