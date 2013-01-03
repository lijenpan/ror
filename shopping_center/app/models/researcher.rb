class Researcher < User

  attr_accessible :research_group_id, :collection_type_id
  belongs_to :research_group
  belongs_to :collection_type
  has_many :shopping_centers, :inverse_of => :researcher
  has_many :collected_retailers, :class_name => "Retailer", :inverse_of => :collector
  has_many :coverage_lists, :class_name => 'CoverageList', :inverse_of => :assignee

  def manager
    ( research_group.nil? ? nil : research_group.research_manager )
  end

  def work_load
    self.tasks.select{|wi| wi.open?}.count
  end
end
