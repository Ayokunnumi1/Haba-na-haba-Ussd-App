class Event < ApplicationRecord
  belongs_to :district
  belongs_to :county
  belongs_to :sub_county
  has_many :event_users
  has_many :users, through: :event_users

  validates :name, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validate :end_time_after_start_time

  private

  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?

    return unless end_date <= start_date

    errors.add(:end_date, 'must be after the start date')
  end

  def end_time_after_start_time
    return if start_time.blank? || end_time.blank?

    return unless end_time <= start_time

    errors.add(:end_time, 'must be after the start time')
  end
end
