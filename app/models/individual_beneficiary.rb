class IndividualBeneficiary < ApplicationRecord
  belongs_to :district
  belongs_to :county
  belongs_to :sub_county
  belongs_to :request

  validates :name, :age, :gender, :residence_address, :village, :parish, :phone_number, presence: true
  validates :case_name, :case_description, :fathers_name, :mothers_name, presence: true
  validates :phone_number, format: { with: /\A[\d+]+\z/, message: 'only allows numbers' }

  def self.apply_filters(params)
    beneficiaries = all
    beneficiaries = beneficiaries.where('name ILIKE ?', "%#{params[:name]}%") if params[:name].present?
    beneficiaries = beneficiaries.where('case_name ILIKE ?', "%#{params[:case_name]}%") if params[:case_name].present?

    if params[:min_age].present? && params[:max_age].present?
      beneficiaries = beneficiaries.where(age: params[:min_age]..params[:max_age])
    elsif params[:min_age].present?
      beneficiaries = beneficiaries.where('age >= ?', params[:min_age])
    elsif params[:max_age].present?
      beneficiaries = beneficiaries.where('age <= ?', params[:max_age])
    end

    if params[:start_date].present? && params[:end_date].present?
      beneficiaries = beneficiaries.where(created_at: Date.parse(params[:start_date])..Date.parse(params[:end_date]))
    end
    beneficiaries
  end
end
