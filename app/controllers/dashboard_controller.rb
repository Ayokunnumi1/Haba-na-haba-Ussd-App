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
    # Base query for Requests based on user role
    request_base_query = case current_user.role
                        when 'super_admin', 'admin'
                          Request.all
                        when 'branch_manager'
                          Request.where(branch_id: current_user.branch_id)
                        when 'volunteer'
                          Request.where(user_id: current_user.id, branch_id: current_user.branch_id)
                        else
                          Request.none # Fallback for unauthorized or guest users
                        end

    # Base query for Inventories based on user role
    inventory_base_query = case current_user.role
                          when 'super_admin', 'admin'
                            Inventory.all
                          when 'branch_manager', 'volunteer'
                            Inventory.where(branch_id: current_user.branch_id)
                          else
                            Inventory.none # Fallback for unauthorized or guest users
                          end

    # Base query for Events based on user role
    event_base_query = case current_user.role
                      when 'super_admin', 'admin'
                        Event.all
                      when 'branch_manager'
                        Event.joins(:district).where(districts: { uuid: BranchDistrict.where(branch_id: current_user.branch_id).select(:district_id) })
                      when 'volunteer'
                        Event.joins(:event_users).where(event_users: { user_id: current_user.id })
                      else
                        Event.none # Fallback for unauthorized or guest users
                      end

    [
      {
        title: 'Pending Request',
        color: '#E0E9FF',
        units: 'Request',
        count: request_base_query.where(is_selected: false).group_by_week(:created_at).count.values.last || '0',
        icon: 'LoanIcons1.svg',
        link: '#'
      },
      {
        title: 'Approved Request',
        color: '#E4FFE0',
        units: 'Request',
        count: request_base_query.where(is_selected: true).group_by_week(:created_at).count.values.last || '0',
        icon: 'LoanIcons2.svg',
        link: '#'
      },
      {
        title: 'Low Stock Alert',
        color: '#FFE0E0',
        units: 'Price',
        count: inventory_base_query.where.not(donor_type: 'cash').group_by_week(:created_at).count.values.last || '0',
        icon: 'LoanIcons3.svg',
        link: '#'
      },
      {
        title: 'Food Events',
        color: '#FFFCE0',
        units: 'Event',
        count: event_base_query.group_by_week(:created_at).count.values.last || '0',
        icon: 'LoanIcons4.svg',
        link: '#'
      }
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
