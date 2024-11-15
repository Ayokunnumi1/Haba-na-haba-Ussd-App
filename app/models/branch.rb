class Branch < ApplicationRecord
  include Matchable
  has_many :branch_districts, dependent: :destroy
  has_many :districts, through: :branch_districts
  has_many :users

  validates :name, :phone_number, presence: true
  validates :phone_number, format: { with: /\A[\d+]+\z/, message: 'only allows numbers' }
end
