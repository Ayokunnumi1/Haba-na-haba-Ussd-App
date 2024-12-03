class FamilyBeneficiary < ApplicationRecord
  include FamilyBeneficiaryFilterable

  belongs_to :district
  belongs_to :county
  belongs_to :sub_county
  belongs_to :request, optional: true
  belongs_to :branch, optional: true
  belongs_to :event, optional: true

  validates :family_members, :male, :female, :children, presence: true
  validates :residence_address, :village, :parish, :phone_number, presence: true
  validates :case_name, :case_description, :fathers_name, :mothers_name, :fathers_occupation, :mothers_occupation,
            presence: true
  validates :phone_number, format: { with: /\A[\d+]+\z/, message: 'only allows numbers' }
  validates :provided_food, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
end
