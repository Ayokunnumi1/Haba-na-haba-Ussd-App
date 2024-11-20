class SubCounty < ApplicationRecord
  include Matchable

  belongs_to :county
  has_many :individual_beneficiaries, dependent: :nullify
  has_many :family_beneficiaries, dependent: :nullify
  has_many :organization_beneficiaries, dependent: :nullify
  has_many :inventories, dependent: :nullify

  validates :name, presence: true
end
