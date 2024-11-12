class District < ApplicationRecord
  has_many :counties
  has_many :branch_districts, dependent: :destroy
  has_many :branches, through: :branch_districts
  has_many :individual_beneficiaries, dependent: :nullify
  has_many :family_beneficiaries, dependent: :nullify
  has_many :organization_beneficiaries, dependent: :nullify
  has_many :inventories, dependent: :nullify

  validates :name, presence: true
end
