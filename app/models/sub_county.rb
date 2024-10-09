class SubCounty < ApplicationRecord
  belongs_to :county
  has_many :individual_beneficiaries
  has_many :family_beneficiaries
  has_many :organization_beneficiaries
end
