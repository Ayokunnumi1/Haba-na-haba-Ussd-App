class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    case user.role
    when 'volunteer'
      volunteer_permissions(user)
    when 'branch_manager'
      branch_manager_permissions(user)
    when 'admin'
      admin_permissions(user)
    when 'super_admin'
      super_admin_permissions(user)
    else
      guest_permissions
    end
  end

  private

  def volunteer_permissions(user)
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
  end

  def branch_manager_permissions(user)
    can :read, User
    can :read, Branch
    can :update, Branch, id: user.branch_id
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
  end

  def admin_permissions(user)
    can :manage, :all
    cannot %i[create update destroy], User, role: 'admin'
    cannot %i[create update destroy], User, role: 'super_admin'
    can :update, User, id: user.id
  end

  def super_admin_permissions(_user)
    can :manage, :all
  end

  def guest_permissions
  can :create, Request
  cannot :manage, all
  end
end
