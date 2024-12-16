class Inventory < ApplicationRecord
  belongs_to :district
  belongs_to :county
  belongs_to :sub_county
  belongs_to :request, optional: true
  belongs_to :branch, optional: true
  belongs_to :event, optional: true

  validates :phone_number, format: { with: /\A[\d+]+\z/, message: 'only allows numbers' }
  validates :collection_amount, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  scope :by_food_type, -> { where(donor_type: %w[dry_food fresh_food other]) }
  scope :donated, -> { joins(:request).where(requests: { request_type: 'food' }) }
  scope :stock_alert, -> { joins(:request).where(requests: { is_selected: true }) }
  scope :expired, -> { where('expire_date < ?', Date.today) }

  scope :by_donation_type, ->(type) { where(donor_type: type) if type.present? }
  scope :by_donation_date, ->(date) { where(collection_date: date) if date.present? }

  scope :by_expire_range, lambda { |start_date, end_date|
    where(expire_date: start_date..end_date) if start_date.present? && end_date.present?
  }

  scope :search_query, lambda { |query|
    where('food_name ILIKE :query OR donor_name ILIKE :query', query: "%#{query}%") if query.present?
  }

  scope :by_collection_amount, lambda { |min_amount, max_amount|
    where(amount: min_amount..max_amount) if min_amount.present? && max_amount.present?
  }

  scope :search, lambda { |query|
    where('food_name ILIKE :query OR donor_name ILIKE :query', query: "%#{query}%")
  }
end
