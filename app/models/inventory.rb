class Inventory < ApplicationRecord
  include InventoriesFilterable
  
  belongs_to :district
  belongs_to :county
  belongs_to :sub_county
  belongs_to :request, optional: true
  belongs_to :branch, optional: true
  belongs_to :event, optional: true

  validates :phone_number, format: { with: /\A[\d+]+\z/, message: 'only allows numbers' }
  validates :collection_amount, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  scope :by_food_name, ->(food_name) { where(food_name: food_name) if food_name.present? }
  scope :by_collection_amount, ->(amount) { where(collection_amount: amount) if amount.present? }
  scope :expired, -> { where('expire_date < ?', Date.today) }

  scope :by_donation_type, ->(type) { where(donation_type: type) if type.present? }
  scope :by_donor_type, ->(type) { where(donor_type: type) if type.present? }
  scope :by_collection_date, ->(date) { where(collection_date: date) if date.present? }
  scope :by_place_of_collection, ->(place) { where(place_of_collection: place) if place.present? }
  scope :by_branch, ->(branch_id) { where(branch_id: branch_id) if branch_id.present? }
  
  # Define the low stock threshold
  LOW_STOCK_THRESHOLD = 30

  # Scope to filter low stock food items
  scope :low_stock, -> { where('food_quantity < ? AND donation_type = ?', LOW_STOCK_THRESHOLD, 'food') }

  # Scope to handle search queries
  scope :search_query, ->(query) {
    where('donor_name ILIKE :query OR food_name ILIKE :query OR cloth_name ILIKE :query OR other_items_name ILIKE :query', query: "%#{query}%") if query.present?
  }
end
