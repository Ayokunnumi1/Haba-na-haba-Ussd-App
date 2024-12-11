class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities based on user role
    user ||= User.new  # guest user (not logged in)

    case user.role
    when 'super_admin'
      # Super admin can do everything
      can :manage, :all
    when 'admin'
     # Admin can manage everything
     can :manage, :all
     # Restrict creating, updating, and deleting users to specific roles
     can [:create, :update, :destroy], User, role: %w[branch_manager volunteer]
     # Restrict admin from managing 'super_admin' and 'admin' roles
     cannot [:create, :update, :destroy], User, role: %w[super_admin admin]
    when 'branch_manager'
      # Branch managers can only manage resources within their branch
      can :manage, Request, branch_id: user.branch_id
      can :read, Event
      can :update, User, branch_id: user.branch_id
      # If branch manager is authorized to read events assigned to their branch
      can :read, EventUser, user_id: user.id
    when 'volunteer'
      # Volunteers can read events and requests
      can :read, Event
      can :read, Request, branch_id: user.branch_id
    else
      # Default to no access for users without a valid role
      cannot :manage, :all
      can :update, User, id: user.id # Can update own profile
    end
  end
end
