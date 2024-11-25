class Inventory < ApplicationRecord
  belongs_to :district
  belongs_to :county
  belongs_to :sub_county
  belongs_to :request, optional: true
  belongs_to :branch, optional: true

  validates :phone_number, format: { with: /\A[\d+]+\z/, message: 'only allows numbers' }
  validates :collection_amount, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
end
