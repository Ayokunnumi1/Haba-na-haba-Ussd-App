class OrganizationBeneficiary < ApplicationRecord
  belongs_to :district
  belongs_to :county
  belongs_to :sub_county
  belongs_to :request

  validates :organization_name, :male, :female, :residence_address, :village, :parish, :phone_number, presence: true
  validates :case_name, :case_description, :registration_no, :organization_no, :directors_name, :head_of_institution,
            presence: true
  validates :phone_number, format: { with: /\A[\d+]+\z/, message: 'only allows numbers' }

  def self.apply_filters(params)
    beneficiaries = OrganizationBeneficiary.all # Ensure this is an ActiveRecord relation

    if params[:organization_name].present?
      beneficiaries = beneficiaries.where('organization_name ILIKE ?',
                                          "%#{params[:organization_name]}%")
    end
    if params[:registration_no].present?
      beneficiaries = beneficiaries.where('registration_no ILIKE ?',
                                          "%#{params[:registration_no]}%")
    end
    beneficiaries = beneficiaries.where('case_name ILIKE ?', "%#{params[:case_name]}%") if params[:case_name].present?
    if params[:phone_number].present?
      beneficiaries = beneficiaries.where('phone_number ILIKE ?',
                                          "%#{params[:phone_number]}%")
    end

    # Filter by people count range
    if params[:min_people].present? || params[:max_people].present?
      min_people = params[:min_people].presence || 0
      max_people = params[:max_people].presence || Float::INFINITY
      beneficiaries = beneficiaries.where('(male + female) BETWEEN ? AND ?', min_people, max_people)
    end

    # Filter by date range
    if params[:start_date].present? && params[:end_date].present?
      beneficiaries = beneficiaries.where(created_at: Date.parse(params[:start_date])..Date.parse(params[:end_date]))
    end

    beneficiaries = beneficiaries.where(district_id: params[:district_id]) if params[:district_id].present?
    beneficiaries = beneficiaries.where(county_id: params[:county_id]) if params[:county_id].present?
    beneficiaries = beneficiaries.where(sub_county_id: params[:sub_county_id]) if params[:sub_county_id].present?

    beneficiaries
  end
end
