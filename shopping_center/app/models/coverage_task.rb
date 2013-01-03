class CoverageTask < Task

  ###fields
  field :snoozes, type: Array, default: []
  field :coverage_policy_id, type: String #stores coverage policy that generated this task, not guaranteed to persist

  ###associations
  belongs_to :retailer
  embedded_in :coverage_list, inverse_of: :tasks

  ###validations
  validates :retailer, presence: true, allow_nil: false
  validates :coverage_policy_id, presence: true, allow_nil: false

  ### validation overrides
  def validate_assignee?
    false
  end

  def validate_due_date?
    true
  end

  def validate_creator?
    false
  end

  ###misc
  def expiration
    snoozes.empty? ? due_date : snoozes.last
  end

  def policy
    self.coverage_list.policies.find(self.coverage_policy_id)
  end

  def assignee
    self.coverage_list.assignee
  end
end
