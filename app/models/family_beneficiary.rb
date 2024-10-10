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
end
