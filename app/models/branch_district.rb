class BranchDistrict < ApplicationRecord
  belongs_to :branch
  belongs_to :district, primary_key: 'uuid'
end