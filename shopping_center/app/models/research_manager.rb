class ResearchManager < User

  attr_accessible :research_group_id
  belongs_to :research_group
  has_many :shopping_centers, :inverse_of => :research_manager

  def researchers
    (research_group ? research_group.researchers : [])
  end
end
