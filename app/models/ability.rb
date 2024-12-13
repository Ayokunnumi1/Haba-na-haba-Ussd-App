class Ability
  include CanCan::Ability

  def initialize(user)
    case user.role
    when 'volunteer'
      can %i[create update read], Request, user_id: user.id
      can %i[create update read], Inventory
      can %i[create update read], IndividualBeneficiary
      can %i[create update read], FamilyBeneficiary
      can %i[create update read], OrganizationBeneficiary
      can :read, User
      can :read, Branch
      can :read, Event
      can :read, District
      can :update, User, id: user.id
    when 'branch_manager'
      can :read, User
      can :read, Branch
      can %i[create update], Branch, id: user.branch_id
      cannot %i[create destroy], Branch
      can :manage, User, role: 'volunteer'
      cannot :update, User, role: 'volunteer'
      cannot %i[create update destroy], User, role: %i[branch_manager admin super_admin]
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
      cannot %i[update destroy], User, role: 'admin'
      cannot %i[create update destroy], User, role: 'super_admin'
      can :update, User, id: user.id
    when 'super_admin'
      can :manage, :all
    end
  end
end
