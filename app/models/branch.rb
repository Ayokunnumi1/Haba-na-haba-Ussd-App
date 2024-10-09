class Branch < ApplicationRecord
  belongs_to :district
  belongs_to :county
  has_many :users

  validates :name, :phone_number, presence: true
  validates :phone_number, format: { with: /\A\d+\z/, message: "only allows numbers" }
end
