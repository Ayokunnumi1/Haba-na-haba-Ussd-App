class County < ApplicationRecord
  belongs_to :district
  has_many :sub_counties
  has_many :individual_beneficiaries
end
