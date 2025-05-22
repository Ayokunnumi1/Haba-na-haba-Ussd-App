class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notifiable, polymorphic: true

  scope :unread, -> { where(read: false) }

  def target_url
    case notifiable_type
    when 'Request'
      Rails.application.routes.url_helpers.request_path(notifiable, notification_id: id)
    else
      '#'
    end
  end
end