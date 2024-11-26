class HomeController < ApplicationController
  def index; end

  def dashboard
    @guidelines = [
      { title: "In Progress Request", units: "Request", count: Request.where(is_selected: false).count, link: "#" },
      { title: "Pending Request", units: "Request", count: Request.where(is_selected: true).count, link: "#" },
      { title: "Low Stock", units: "Price", count: Inventory.count, link: "#" },
      { title: "Expiring Soon", units: "Pieces", count: Inventory.count, link: "#" },
      { title: "Food Events", units: "Event", count: Event.count, link: "#" }
    ]

    @beneficiary_data = {
      "Individual Beneficiaries" => IndividualBeneficiary.count,
      "Family Beneficiaries" => FamilyBeneficiary.count,
      "Organization Beneficiaries" => OrganizationBeneficiary.count
    }
  end

  layout 'home', only: [:dashboard]
end
