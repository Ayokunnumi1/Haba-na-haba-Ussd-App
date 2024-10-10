class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  belongs_to :branch, optional: true
  has_many :event_users
  has_many :events, through: :event_users

  ROLES = %w[super_admin admin branch_manager volunteer].freeze

  validates :first_name, :last_name, :phone_number, :role, presence: true
  validates :phone_number, format: { with: /\A[\d+]+\z/, message: 'only allows numbers' }
  validates :role, inclusion: { in: ROLES, message: '%<value>s is not a valid role' }

  ROLES.each do |role_name|
    define_method "#{role_name.gsub(' ', '_')}?" do
      role == role_name.tr('_', ' ')
    end
  end
end
