class User < ApplicationRecord
  devise :database_authenticatable, :recoverable, :validatable

  belongs_to :branch, optional: true
  has_many :event_users
  has_many :events, through: :event_users
  has_one_attached :image
  
  ROLES = %w[super_admin admin branch_manager volunteer].freeze

  validates :first_name, :last_name, :phone_number, :role, :gender, :location, presence: true
  validates :phone_number, format: { with: /\A[\d\+\-\(\)\s]+\z/, message: 'only allows valid phone numbers' }
  validates :role, inclusion: { in: ROLES, message: '%<value>s is not a valid role' }
  validates :password, presence: { message: 'Password cannot be blank' },
                       confirmation: { message: 'Password confirmation does not match' },
                       length: { within: 6..128, message: 'Password must be between 6 and 128 characters long' },
                       if: :password_required?

  ROLES.each do |role_name|
    define_method "#{role_name.gsub(' ', '_')}?" do
      role == role_name.tr('_', ' ')
    end
  end

  def full_gender
    case gender
    when 'F'
      'Female'
    when 'M'
      'Male'
    else
      'Unknown'
    end
  end

  private

  def password_required?
    new_record? || password.present?
  end
end
