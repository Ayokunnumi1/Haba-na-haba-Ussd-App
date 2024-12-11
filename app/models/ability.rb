class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new 

    case user.role
    when 'super_admin'
      can :manage, :all
    when 'admin'
      can :manage, :all
      can [:create], User, role: 'admin' # Allow admin to create other admins
      cannot [:update, :destroy], User, role: 'admin' # Disallow updating or destroying admins
      can [:create, :update, :destroy], User, role: %w[branch_manager volunteer] # Manage branch_manager and volunteer
      cannot [:create, :update, :destroy], User, role: 'super_admin' # No permissions for super_admin
      
    when 'branch_manager'
      can :read, Branch
      can [:create, :update], Branch, id: user.branch_id
      cannot [:create, :destroy], Branch

      # Branch managers can manage requests belonging to their branch
      can :manage, Request, branch_id: user.branch_id

      # Branch managers can create and update volunteers in their branch
      can [:create, :update], User, role: 'volunteer', branch_id: user.branch_id

      # Branch managers cannot edit or delete other branch managers, admins, or super admins
      cannot [:create, :update, :destroy], User, role: %w[branch_manager admin super_admin]

      # Branch managers can only update their own profile
      can :update, User, id: user.id

      # Branch managers cannot create districts
      cannot :create, District
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
