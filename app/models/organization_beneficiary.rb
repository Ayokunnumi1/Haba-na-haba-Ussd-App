class OrganizationBeneficiary < ApplicationRecord
  include OrganizationBeneficiaryFilterable

  belongs_to :district
  belongs_to :county
  belongs_to :sub_county
  belongs_to :request, optional: true
  belongs_to :branch, optional: true

  validates :organization_name, :male, :female, :residence_address, :village, :parish, :phone_number, presence: true
  validates :case_name, :case_description, :registration_no, :organization_no, :directors_name, :head_of_institution,
            presence: true
  validates :phone_number, format: { with: /\A[\d+]+\z/, message: 'only allows numbers' }
  validates :provided_food, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
end
