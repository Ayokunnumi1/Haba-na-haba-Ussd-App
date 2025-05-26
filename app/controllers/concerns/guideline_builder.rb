module GuidelineBuilder
  extend ActiveSupport::Concern

  private

  def build_guidelines
    [
      build_guideline('Pending Request', '#E0E9FF', 'Request', request_base_query.where(is_selected: false), 'LoanIcons1.svg'),
      build_guideline('Approved Request', '#E4FFE0', 'Request', request_base_query.where(is_selected: true), 'LoanIcons2.svg'),
      build_guideline('Low Stock Alert', '#FFE0E0', 'Price', inventory_base_query.where.not(donor_type: 'cash'), 'LoanIcons3.svg'),
      build_guideline('Food Events', '#FFFCE0', 'Event', event_base_query, 'LoanIcons4.svg')
    ]
  end

  def build_guideline(title, color, units, query, icon)
    {
      title: title,
      color: color,
      units: units,
      count: query.group_by_week(:created_at).count.values.last || '0',
      icon: icon,
      link: '#'
    }
  end

  def request_base_query
    case current_user.role
    when 'super_admin', 'admin'
      Request.all
    when 'branch_manager'
      Request.where(branch_id: current_user.branch_id)
    when 'volunteer'
      Request.where(user_id: current_user.id, branch_id: current_user.branch_id)
    else
      Request.none
    end
  end

  def inventory_base_query
    case current_user.role
    when 'super_admin', 'admin'
      Inventory.all
    when 'branch_manager', 'volunteer'
      Inventory.where(branch_id: current_user.branch_id)
    else
      Inventory.none
    end
  end

  def event_base_query
    case current_user.role
    when 'super_admin', 'admin'
      Event.all
    when 'branch_manager'
      Event.joins(:district).where(districts: { uuid: BranchDistrict.where(branch_id: current_user.branch_id).select(:district_id) })
    when 'volunteer'
      Event.joins(:event_users).where(event_users: { user_id: current_user.id })
    else
      Event.none
    end
  end
end