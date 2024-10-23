class Inventory < ApplicationRecord
  belongs_to :district
  belongs_to :county
  belongs_to :sub_county
  belongs_to :request

  validates :donor_name, :donor_type, :collection_date, :food_name, :expire_date, presence: true
  validates :phone_number, :amount, presence: true
  validates :phone_number, format: { with: /\A[\d+]+\z/, message: 'only allows numbers' }
end
