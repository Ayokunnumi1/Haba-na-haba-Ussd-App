class DashboardController < ApplicationController
  load_and_authorize_resource except: :index
  before_action :set_group_by, only: :index
  before_action :set_counts, only: :index
  before_action :set_dashboard_data, only: :index

  def index
    respond_to do |format|
      format.html
      format.turbo_stream { render partial: 'charts' }
    end
  end

  private

  def set_group_by
    allowed_groupings = %w[day week month]
    @group_by = params[:group_by].in?(allowed_groupings) ? params[:group_by] : 'week'
  end

  def set_counts
    @staffs = User.count
    @volunteers = User.where(role: 'volunteer').count
    @total_beneficiaries = (IndividualBeneficiary.count || 0) + (FamilyBeneficiary.count || 0) + (OrganizationBeneficiary.count || 0)
    @total_donor = Inventory.count
  end

  def set_dashboard_data
    @guidelines = build_guidelines
    @donations_by_district = Inventory.joins(:district).group('districts.name').count
    @inventory_trends = Inventory.group(:donor_type).send("group_by_#{@group_by}", :created_at).count
    @events_per_week = Event.joins(:event_users).send("group_by_#{@group_by}", :created_at).distinct.count(:id)
    @users_per_week = EventUser.send("group_by_#{@group_by}", :created_at).distinct.count(:user_id)
    @chart_data = Request.group(:request_type).send("group_by_#{@group_by}", :created_at).count
    @beneficiary_data = build_beneficiary_data
  end

  def build_guidelines
    [
      { title: 'Pending Request', color: '#E0E9FF', units: 'Request', count: Request.where(is_selected: false).group_by_week(:created_at).count.values.last || 'N/A', icon: 'LoanIcons1.svg',
        link: '#' },
      { title: 'Approved Request', color: '#E4FFE0', units: 'Request', count: Request.where(is_selected: true).group_by_week(:created_at).count.values.last || 'N/A', icon: 'LoanIcons2.svg',
        link: '#' },
      { title: 'Low Stock Alert', color: '#FFE0E0', units: 'Price', count: Inventory.where.not(donor_type: 'cash').group_by_week(:created_at).count.values.last || 'N/A',
        icon: 'LoanIcons3.svg', link: '#' },
      { title: 'Food Events', color: '#FFFCE0', units: 'Event', count: Event.group_by_week(:created_at).count.values.last || 'N/A', icon: 'LoanIcons4.svg', link: '#' }
    ]
  end

  def build_beneficiary_data
    {
      'Individual Beneficiaries' => IndividualBeneficiary.count,
      'Family Beneficiaries' => FamilyBeneficiary.count,
      'Organization Beneficiaries' => OrganizationBeneficiary.count
    }
  end
end
