class Task
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  validates :title, presence: true

  field :description, type: String
  validates :description, presence: true

  field :due_date, type: DateTime
  validates :due_date, presence: true, allow_nil: false, if: :validate_due_date?

  field :closed_at, type: Array, default: []

  belongs_to :creator, :class_name => "User", :inverse_of => :created_tasks
  validates :creator, presence: true, allow_blank: false, allow_nil: false, if: :validate_creator?

  belongs_to :assignee, :class_name => "User", :inverse_of => :tasks
  validates :assignee, presence: true, allow_blank: false, allow_nil: false, if: :validate_assignee?

  embeds_many :comments, :as => :commentable

  state_machine :initial => :open do
    state :open
    state :closed

    after_transition :open => :closed do |task, transition|
      AWSUtil.delete("website_index", task.title)
      task.closed_at << [DateTime.now, task.assignee]
    end

    event :close do
      transition :open => :closed
    end

    event :reopen do
      transition :closed => :open
    end
  end

  def validate_due_date?
    false
  end

  def validate_creator?
    true
  end

  def validate_assignee?
    true
  end

  def open?
    state == "open"
  end

  def closed?
    !open?
  end

  #returns the duration of the task in seconds from start to (completed || now)
  def duration(t = DateTime.now)
    (1.days * ((closed_at || t).to_datetime - created_at.to_datetime)).to_i
  end

  def expiration
    self.due_date
  end

  def expired?
    return false if expiration.nil?
    return false if expiration > Time.now
    return true
  end

  def <=> other
    return 0 if !self.expiration && !other.expiration
    return 1 if !self.expiration
    return -1 if !other.expiration
    self.expiration <=> other.expiration
  end

  ###scopes
  def self.event_translator(e)
    e
  end

  def self.is?(state=nil)
    return where(state: state.to_s) if state
    all
  end

  def self.assigned_to(*users)
    return any_in(assignee_id: users.collect(&:id)) unless users.empty?
    all
  end
end
