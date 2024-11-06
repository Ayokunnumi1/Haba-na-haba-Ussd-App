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
    beneficiaries = all
    Rails.logger.debug("Initial beneficiaries count: #{beneficiaries.count}")

    if params[:district_id].present?
      beneficiaries = beneficiaries.where(district_id: params[:district_id])
      Rails.logger.debug("After district filter: #{beneficiaries.count}")
    end

    if params[:county_id].present?
      beneficiaries = beneficiaries.where(county_id: params[:county_id])
      Rails.logger.debug("After county filter: #{beneficiaries.count}")
    end

    if params[:sub_county_id].present?
      beneficiaries = beneficiaries.where(sub_county_id: params[:sub_county_id])
      Rails.logger.debug("After sub-county filter: #{beneficiaries.count}")
    end

    beneficiaries
  end
end
