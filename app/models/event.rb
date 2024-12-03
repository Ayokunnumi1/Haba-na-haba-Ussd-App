class Event < ApplicationRecord
  belongs_to :district
  belongs_to :county
  has_many :requests, dependent: :destroy
  belongs_to :sub_county
  has_many :event_users, dependent: :destroy
  has_many :users, through: :event_users
  has_many :individual_beneficiaries, dependent: :destroy

  validates :name, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validate :end_date_after_start_date
  validate :end_time_after_start_time

  private

  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?

    return unless end_date < start_date

    errors.add(:end_date, 'must be after or on the same day as the start date')
  end

  def end_time_after_start_time
    return if start_time.blank? || end_time.blank? || start_date.blank? || end_date.blank?

    return unless start_date == end_date && end_time <= start_time

    errors.add(:end_time, 'must be after the start time if the event is on the same day')
  end
end
