class SubCounty < ApplicationRecord
  belongs_to :county
  has_many :individual_beneficiaries
end
