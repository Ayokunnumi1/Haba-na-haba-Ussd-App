class Ability
  include CanCan::Ability

  def initialize(user)
    case user.role
    when 'volunteer'
      can :read, User
      can :read, Branch
      can [:create, :update, :read], Request, user_id: user.id
      can [:create, :update, :read], Inventory
      can [:create, :update, :read], IndividualBeneficiary
      can [:create, :update, :read], FamilyBeneficiary
      can [:create, :update, :read], OrganizationBeneficiary
      can :read, Event
      can :read, District
      can :update, User, id: user.id
    when 'branch_manager'
      can :read, User
      can :read, Branch
      can [:create, :update], Branch, id: user.branch_id
      cannot [:create, :destroy], Branch
      can :manage, User, role: 'volunteer'
      cannot :update, User, role: 'volunteer'
      cannot [:create, :update, :destroy], User, role: %w[branch_manager admin super_admin]
      can :manage, Request, branch_id: user.branch_id
      can :manage, Inventory, branch_id: user.branch_id
      can :manage, IndividualBeneficiary, branch_id: user.branch_id
      can :manage, FamilyBeneficiary, branch_id: user.branch_id
      can :manage, OrganizationBeneficiary, branch_id: user.branch_id
      can :manage, Event
      cannot :destroy, Event
      can :manage, District
      cannot :destroy, District
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
