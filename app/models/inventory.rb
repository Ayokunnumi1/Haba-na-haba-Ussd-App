class Inventory < ApplicationRecord
  belongs_to :district
  belongs_to :county
  belongs_to :sub_county
  belongs_to :request

  validates :phone_number, format: { with: /\A[\d+]+\z/, message: 'only allows numbers' }
end
