class User
  include Mongoid::Document
  include Mongoid::Timestamps

  ROLES = [:admin, :researcher, :research_manager, :product_manager]

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable,
         :lockable

  # database_authenticatable
  field :email, :type => String, :null => false
  field :encrypted_password, :type => String, :null => false

  # recoverable
  field :reset_password_token, :type => String
  field :reset_password_sent_at, :type => Time

  # rememberable
  field :remember_created_at, :type => Time

  # trackable
  field :sign_in_count, :type => Integer
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at, :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip, :type => String

  # # encryptable
  # field :password_salt, :type => String

  # confirmable
  #field :confirmation_token, :type => String
  #field :confirmed_at, :type => Time
  #field :confirmation_sent_at, :type => Time
  #field :unconfirmed_email, :Type => String

  # lockable
  field :failed_attempts, :type => Integer
  field :unlock_token, :type => String
  field :locked_at, :type => Time

  has_many :tasks, :class_name => "Task", :inverse_of => :assignee
  has_many :created_tasks, :class_name => "Task", :inverse_of => :creator

  # token authenticatable
  # field :authentication_token, :type => String

  # # invitable
  # field :invitation_token, :type => String

  validates_uniqueness_of :email, :case_sensitive => false
  validates_presence_of :first_name, :last_name
  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation, :remember_me

  field :first_name, type: String
  field :last_name, type: String

  #TODO add specs
  def role
    self.class.to_s.underscore.to_sym
  end

  def has_manager?
    respond_to?(:manager) && !manager.nil?
  end

  def has_collection_type?
    respond_to?(:collection_type) && !collection_type.nil?
  end

  def name
    @name ||= "#{first_name} #{last_name}".titleize
  end

  def username
    @name ||= "#{first_name.first}#{last_name}".downcase
  end

  def is? *roles
    return roles.select{|r| not r.nil?}.include?(self.role)
  end

  def dashboard_path
    "/#{self.class.to_s.underscore}/dashboard"
  end

  def self.COVERAGE_TASK_BOT
    User.find_or_create_by(email: 'abot@pps.com', first: 'admin', last: 'bot', password: 'something', password_confirmation: 'something')
  end
end
