class OrganizationBeneficiary < ApplicationRecord
  belongs_to :district
  belongs_to :county
  belongs_to :sub_county
  belongs_to :request

  validates :organization_name, :male, :female, :residence_address, :village, :parish, :phone_number, presence: true
  validates :case_name, :case_description, :registration_no, :organization_no, :directors_name, :head_of_institution, presence: true
  validates :phone_number, format: { with: /\A[\d+]+\z/, message: "only allows numbers" }
end
