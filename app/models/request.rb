class Request < ApplicationRecord
  include RequestFilterable

  belongs_to :district
  belongs_to :county
  belongs_to :sub_county
  belongs_to :branch
  belongs_to :event, optional: true
  belongs_to :user, optional: true
  has_one :individual_beneficiary, dependent: :destroy
  has_one :family_beneficiary, dependent: :destroy
  has_one :organization_beneficiary, dependent: :destroy
  has_many :inventories, dependent: :nullify
  has_many :notifications, as: :notifiable, dependent: :destroy

  validates :name, :phone_number, :request_type, presence: true
  validates :phone_number, format: { with: /\A[\d+]+\z/, message: 'only allows numbers' }
end
