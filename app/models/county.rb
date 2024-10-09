class County < ApplicationRecord
  belongs_to :district
  has_many :sub_counties
  has_many :individual_beneficiaries
  has_many :family_beneficiaries
  has_many :organization_beneficiaries
end
