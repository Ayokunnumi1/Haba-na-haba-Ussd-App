class Inventory < ApplicationRecord
  belongs_to :district
  belongs_to :county
  belongs_to :subcounty
  belongs_to :request

  validates :donor_name, :donor_type, :collection_date, :food_name, :expire_date, presence: true
  validates :district_id, :county_id, :subcounty_id, :village_address, :residence_address, presence: true
  validates :phone_number, :parish, :amount, :head_of_institution, :registration_no, :request_id, presence: true
  validates :phone_number, format: { with: /\A[\d+]+\z/, message: 'only allows numbers' }
end
