class County < ApplicationRecord
  belongs_to :district
  has_many :sub_counties
  has_many :individual_beneficiaries, dependent: :nullify
  has_many :family_beneficiaries, dependent: :nullify
  has_many :organization_beneficiaries, dependent: :nullify
  has_many :inventories, dependent: :nullify
end
