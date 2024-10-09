class IndividualBeneficiary < ApplicationRecord
  belongs_to :district
  belongs_to :county
  belongs_to :sub_county
  belongs_to :request

  validates :name, :age, :gender, :residence_address, :village, :parish, :phone_number, presence: true
  validates :case_name, :case_description, :fathers_name, :mothers_name, :sur_name, presence: true
  validates :phone_number, format: { with: /\A[\d+]+\z/, message: "only allows numbers" }
end
