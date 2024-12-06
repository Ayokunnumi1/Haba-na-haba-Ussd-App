class DashboardController < ApplicationController
  def index
    @staffs = User.all.count
    @volunteers = User.where(role: 'volunteer').count
    @guidelines = [
      { title: 'In Progress Request', color: '#E0E9FF', units: 'Request', count: Request.where(is_selected: false).count, icon: 'LoanIcons1.svg', link: '#' },
      { title: 'Pending Request', color: '#E4FFE0', units: 'Request', count: Request.where(is_selected: true).count, icon: 'LoanIcons2.png', link: '#' },
      { title: 'Low Stock', color: '#FFE0E0', units: 'Price', count: Inventory.where('expire_date <= ?', Date.today + 15).count, icon: 'LoanIcons3.svg', link: '#' },
      { title: 'Expiring Soon', color: '#FFFCE0', units: 'Pieces', count: Inventory.where('expire_date <= ?', Date.today + 15).count, icon: 'LoanIcons4.png', link: '#' },
      { title: 'Food Events', color: '#FFFCE0', units: 'Event', count: Event.count, icon: 'LoanIcons4.png', link: '#' }
    ]

    @donations_by_district = Inventory.joins(:district).group('districts.name')
      .sum(:amount)

    @inventory_trends = Inventory.group(:donor_type).group_by_day(:created_at).count
    
    # @requests_by_branch = Branch.includes(:districts).each_with_object({}) do |branch, series|
    #   requests = Request.joins(:branch_districts)
    #     .where(branch_districts: { branch_id: branch.id })
    #   series[branch.name] = requests.group_by_month(:created_at).count
    # end

    # @requests_by_branch = Request.joins(:branch).group(:request.branch_id)
      
    @chart_data = Request.group(:request_type).group_by_second(:created_at).count

    @beneficiary_data = {
      'Individual Beneficiaries' => IndividualBeneficiary.count,
      'Family Beneficiaries' => FamilyBeneficiary.count,
      'Organization Beneficiaries' => OrganizationBeneficiary.count
    }

end
end
