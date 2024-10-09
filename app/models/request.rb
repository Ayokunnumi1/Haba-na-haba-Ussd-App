class Request < ApplicationRecord
  belongs_to :district
  belongs_to :county
  belongs_to :sub_county
  belongs_to :branch
  belongs_to :user, optional: true
  has_one :individual_beneficiary, dependent: :destroy

  validates :name, :phone_number, :request_type, :residence_address, :village, :parish, presence: true
  validates :phone_number, format: { with: /\A[\d+]+\z/, message: "only allows numbers" }
end
