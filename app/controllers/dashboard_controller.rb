class DashboardController < ApplicationController
  def index
    group_by = params[:group_by] || "week" # Default to "week" if not provided
    allowed_groupings = %w[day week month]
    group_by = allowed_groupings.include?(group_by) ? group_by : "week" # Ensure valid input

    @staffs = User.all.count
    @volunteers = User.where(role: 'volunteer').count
    @guidelines = [
      { title: 'In Progress Request', color: '#E0E9FF', units: 'Request', count: Request.where(is_selected: false).count, icon: 'LoanIcons1.svg', link: '#' },
      { title: 'Pending Request', color: '#E4FFE0', units: 'Request', count: Request.where(is_selected: true).count, icon: 'LoanIcons2.png', link: '#' },
      { title: 'Low Stock', color: '#FFE0E0', units: 'Price', count: Inventory.where('expire_date <= ?', Date.today + 15).count, icon: 'LoanIcons3.svg', link: '#' },
      { title: 'Expiring Soon', color: '#FFFCE0', units: 'Pieces', count: Inventory.where('expire_date <= ?', Date.today + 15).count, icon: 'LoanIcons4.png', link: '#' },
      { title: 'Food Events', color: '#FFFCE0', units: 'Event', count: Event.count, icon: 'LoanIcons4.png', link: '#' }
    ]

    # Dynamically group data based on the selected group_by value
    @donations_by_district = Inventory.joins(:district).group('districts.name').sum(:amount)

    @inventory_trends = Inventory.group(:donor_type).send("group_by_#{group_by}", :created_at).count

    @events_per_week = Event.joins(:event_users).send("group_by_#{group_by}", :created_at).distinct.count(:id)

    @users_per_week = EventUser.send("group_by_#{group_by}", :created_at).distinct.count(:user_id)

    @chart_data = Request.group(:request_type).send("group_by_#{group_by}", :created_at).count

    @beneficiary_data = {
      'Individual Beneficiaries' => IndividualBeneficiary.count,
      'Family Beneficiaries' => FamilyBeneficiary.count,
      'Organization Beneficiaries' => OrganizationBeneficiary.count
    }

    respond_to do |format|
      format.html
      format.turbo_stream { render partial: "charts" }
    end
  end
end
