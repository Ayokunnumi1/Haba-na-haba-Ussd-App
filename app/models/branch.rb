class Branch < ApplicationRecord
  belongs_to :district
  belongs_to :county
end
