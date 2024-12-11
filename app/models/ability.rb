class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new 

    case user.role
    when 'super_admin'
      can :manage, :all
    when 'admin'
     can :manage, :all
     can [:create, :update, :destroy], User, role: %w[branch_manager volunteer]
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
