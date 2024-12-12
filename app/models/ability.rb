# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    case user.role
    when 'volunteer'
      # Volunteers can read events and requests
      can :read, Event
      can :read, Request, branch_id: user.branch_id
    when 'branch_manager'
      can :read, User
      can :read, Branch
      can [:create, :update], Branch, id: user.branch_id
      cannot [:create, :destroy], Branch
      can :manage, Request, branch_id: user.branch_id
      can :manage, User, role: 'volunteer'
      cannot :update, User, role:'volunteer'
      cannot [:create, :update, :destroy], User, role: %w[branch_manager admin super_admin]
      can :update, User, id: user.id
    when 'admin'
      can :manage, :all
      cannot [:update, :destroy], User, role: 'admin'
      cannot [:create, :update, :destroy], User, role: 'super_admin' 
      can :update, User, id: user.id
    when 'super_admin'
      can :manage, :all
    end
  end
end
