class District < ApplicationRecord
  has_many :counties
  has_many :individual_beneficiaries
end
