class Request < ApplicationRecord
  belongs_to :district
  belongs_to :county
  belongs_to :sub_county
  belongs_to :branch
  belongs_to :user, optional: true
  has_one :individual_beneficiary, dependent: :destroy
  has_one :family_beneficiary, dependent: :destroy
  has_one :organization_beneficiary, dependent: :destroy
  has_many :inventories, dependent: :destroy

  validates :name, :phone_number, :request_type, :residence_address, presence: true
  validates :phone_number, format: { with: /\A[\d+]+\z/, message: 'only allows numbers' }

  scope :by_request_type, ->(type) { where(request_type: type) if type.present? }

  scope :search_query, lambda { |query|
    if query.present?
      joins(:inventories).where(
        'donor_name ILIKE :query OR inventories.donor_type ILIKE :query',
        query: "%#{query}%"
      ).distinct
    end
  }

  scope :by_donation_type, lambda { |donation_type|
    joins(:inventories).where(inventories: { donor_type: donation_type }) if donation_type.present?
  }

  # Scope for filtering by donation date range
  scope :by_donation_date, lambda { |start_date, end_date|
    where(created_at: start_date..end_date) if start_date.present? && end_date.present?
  }
end
