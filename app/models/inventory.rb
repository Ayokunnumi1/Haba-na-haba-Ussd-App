class Inventory < ApplicationRecord
  belongs_to :district
  belongs_to :county
  belongs_to :sub_county
  belongs_to :request

  validates :donor_name, :donor_type, :collection_date, :food_name, :expire_date, presence: true
  validates :phone_number, :amount, presence: true
  validates :phone_number, format: { with: /\A[\d+]+\z/, message: 'only allows numbers' }

  scope :by_donation_type, ->(type) { where(donation_type: type) if type.present? }
  scope :by_donation_date, ->(date) { where(donation_date: date) if date.present? }
  scope :by_collection_range, ->(start_date, end_date) {
    where(collection_date: start_date..end_date) if start_date.present? && end_date.present?
  }
  scope :by_collection_amount, ->(amount) { where("collection_amount >= ?", amount) if amount.present? }

  scope :search, ->(query) {
    where("food_name ILIKE :query OR donor_name ILIKE :query", query: "%#{query}%")
  }
end
