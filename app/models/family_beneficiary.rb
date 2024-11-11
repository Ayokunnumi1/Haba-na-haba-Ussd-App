class FamilyBeneficiary < ApplicationRecord
  belongs_to :district
  belongs_to :county
  belongs_to :sub_county
  belongs_to :request

  validates :family_members, :male, :female, :children, presence: true
  validates :residence_address, :village, :parish, :phone_number, presence: true
  validates :case_name, :case_description, :fathers_name, :mothers_name, :fathers_occupation, :mothers_occupation,
            presence: true
  validates :phone_number, format: { with: /\A[\d+]+\z/, message: 'only allows numbers' }

  def self.apply_filters(params)
    beneficiaries = FamilyBeneficiary.all

    if params[:fathers_name].present?
      beneficiaries = beneficiaries.where('fathers_name ILIKE ?',
                                          "%#{params[:fathers_name]}%")
    end
    if params[:mothers_name].present?
      beneficiaries = beneficiaries.where('mothers_name ILIKE ?',
                                          "%#{params[:mothers_name]}%")
    end
    beneficiaries = beneficiaries.where('case_name ILIKE ?', "%#{params[:case_name]}%") if params[:case_name].present?
    if params[:phone_number].present?
      beneficiaries = beneficiaries.where('phone_number ILIKE ?',
                                          "%#{params[:phone_number]}%")
    end

    if params[:min_member].present? && params[:max_member].present?
      beneficiaries = beneficiaries.where(family_members: params[:min_member]..params[:max_member])
    elsif params[:min_member].present?
      beneficiaries = beneficiaries.where('family_members >= ?', params[:min_member])
    elsif params[:max_member].present?
      beneficiaries = beneficiaries.where('family_members <= ?', params[:max_member])
    end

    if params[:start_date].present? && params[:end_date].present?
      beneficiaries = beneficiaries.where(created_at: Date.parse(params[:start_date])..Date.parse(params[:end_date]))
    end

    beneficiaries = beneficiaries.where(district_id: params[:district_id]) if params[:district_id].present?
    beneficiaries = beneficiaries.where(county_id: params[:county_id]) if params[:county_id].present?
    beneficiaries = beneficiaries.where(sub_county_id: params[:sub_county_id]) if params[:sub_county_id].present?

    beneficiaries
  end
end
