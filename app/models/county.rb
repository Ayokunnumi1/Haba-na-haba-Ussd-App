class County < ApplicationRecord
  include Matchable

  belongs_to :district
  has_many :sub_counties, dependent: :destroy
  accepts_nested_attributes_for :sub_counties, 
    reject_if: -> (attributes) { attributes[:description].blank? }, 
    allow_destroy: true
  has_many :individual_beneficiaries, dependent: :nullify
  has_many :family_beneficiaries, dependent: :nullify
  has_many :organization_beneficiaries, dependent: :nullify
  has_many :inventories, dependent: :nullify

  validates :name, presence: true
end
