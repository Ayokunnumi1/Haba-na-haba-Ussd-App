class Branch < ApplicationRecord
  include Matchable
  has_many :branch_districts, dependent: :destroy
  has_many :districts, through: :branch_districts
  has_many :users

  validates :name, presence: { message: "is required" }
  validates :phone_number, 
            presence: { message: "is required" },
            format: { with: /\A[\d+]+\z/, message: "must only contain numbers" }
  validate :must_have_at_least_one_district

  private

def must_have_at_least_one_district
  errors.add(:district_ids, "must select at least one district") if district_ids.blank?
end
  
end
