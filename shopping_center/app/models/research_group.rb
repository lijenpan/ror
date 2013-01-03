class ResearchGroup
  include Mongoid::Document
  include Mongoid::Timestamps

  has_one :research_manager
  has_many :researchers
  has_many :coverage_lists

  field :name, type: String
  validates :name, presence: true

  def open_tasks
    return [] if researchers.empty?
    Task.assigned_to(*self.researchers).is?(:open)
  end

  def open_shopping_centers
    return [] if researchers.empty?

    criteria = ShoppingCenter.waiting_on_researcher.collected_by(*self.researchers)
    # criteria.merge(ShoppingCenter.waiting_on_research_manager.verified_by(research_manager.id))
  end
end
