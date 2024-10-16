class Request < ApplicationRecord
  belongs_to :district, optional: true
  belongs_to :county, optional: true
  belongs_to :sub_county, optional: true
  belongs_to :branch, optional: true
  belongs_to :user, optional: true

  has_one :individual_beneficiary, dependent: :destroy
  has_one :family_beneficiary, dependent: :destroy
  has_one :organization_beneficiary, dependent: :destroy
  has_many :inventories, dependent: :nullify

  validates :name, :phone_number, presence: true
  validates :phone_number, format: { with: /\A[\d+]+\z/, message: 'only allows numbers' }
end
