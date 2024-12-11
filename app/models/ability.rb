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
      # Admin can manage all except users and roles
      can :manage, :all
      cannot :manage, User
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
    end
  end
end
