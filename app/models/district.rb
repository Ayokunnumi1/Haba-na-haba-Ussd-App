class District < ApplicationRecord
  has_many :counties, dependent: :destroy
  has_many :individual_beneficiaries, dependent: :nullify
  has_many :family_beneficiaries, dependent: :nullify
  has_many :organization_beneficiaries, dependent: :nullify
  has_many :inventories, dependent: :nullify
end
