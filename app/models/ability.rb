# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    case user.role
    when 'super_admin'
      can :manage, :all
    when 'admin'
      can :manage, :all
      cannot [:update, :destroy], User, role: 'admin'
      cannot [:create, :update, :destroy], User, role: 'super_admin' 
    when 'branch_manager'
      can :manage, User
      can :read, Branch
      can [:create, :update], Branch, id: user.branch_id
      cannot [:create, :destroy], Branch
      can :manage, Request, branch_id: user.branch_id

      cannot [:update, :destroy], User, role: 'admin'
      cannot [:create, :update, :destroy], User, role: 'super_admin' 

      # Branch managers can create and update volunteers in their branch
      can [:create, :update], User, role: 'volunteer'

      # Branch managers cannot edit or delete other branch managers, admins, or super admins
      cannot [:create, :update, :destroy], User, role: %w[branch_manager admin super_admin]

      # Branch managers can only update their own profile
      can :update, User, id: user.id
    when 'volunteer'
      # Volunteers can read events and requests
      can :read, Event
      can :read, Request, branch_id: user.branch_id
    end
  end
end
