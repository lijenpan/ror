class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new #guest user

    can :update, User, :id => user.id
    can :read, User
    can [:update, :destroy], Comment, :author => user.id.to_s
    can [:create, :read], Comment

    can :change_state, Task, :assignee => user
    can :change_state, Task, {:creator => user, :state => 'completed'}
    can [:destroy, :edit, :update], Task, :creator => user

    #TODO figure out how to do this idiom differently
    can :assign_research_manager, User if user.is?(:admin, :product_manager)
    can :navigate, [CoverageList, Task] if user.is?(:research_manager)
    can :read, CoverageList

    can :dashboard, Admin if user.is? :admin
    can :dashboard, ResearchManager if user.is? :research_manager
    can :dashboard, Researcher if user.is? :researcher
    can :dashboard, ProductManager if user.is? :product_manager

    can :assign_user_role, User if(user.is?(:admin) || user.is?(:product_manager))

    if user.is? :admin
      can :manage, :all
      can :become, User
    elsif user.is? :product_manager
      can :manage, Message
      can [:show, :create, :new, :edit, :update, :destroy], User
      can :manage, Task
      can :read, [ShoppingCenter, Retailer]
    elsif user.is? :research_manager
      can :read, :all
      can :manage, Message
      can [:update, :edit], ShoppingCenter, :state => ["awaiting_verification", "manager_collecting"]
      can :change_state, ShoppingCenter, :state => ["manager_collecting", "awaiting_verification", "searchable", "trashed", "stalled"]
      can [:read, :create], Task
      can :manage, Retailer

      can [:create, :new], CoverageList do |cl|
        not user.research_group.nil?
      end

      can [:edit, :update, :destroy], CoverageList do |cl|
        cl.research_group.id = user.research_group.id
      end
    elsif user.is? :researcher
      can :manage, Retailer
      can [:create, :read], ShoppingCenter
      can [:update, :edit], ShoppingCenter, :state => ["awaiting_promotion", "researcher_collecting"]
      can :change_state, ShoppingCenter, :state => ["researcher_collecting", "awaiting_promotion", "incomplete", "error"]
      can [:read], [Task, Message]
    end
  end
end
