class Branch < ApplicationRecord
  has_many :branch_districts, dependent: :destroy
  has_many :districts, through: :branch_districts
  belongs_to :county
  has_many :users

  validates :name, :phone_number, presence: true
  validates :phone_number, format: { with: /\A[\d+]+\z/, message: 'only allows numbers' }
end
