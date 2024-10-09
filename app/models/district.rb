class District < ApplicationRecord
  has_many :counties
  has_many :individual_beneficiaries
  has_many :family_beneficiaries
  has_many :organization_beneficiaries
end
