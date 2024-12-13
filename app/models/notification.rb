class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notifiable, polymorphic: true

  def target_url
    case notifiable_type
    when 'Request'
      Rails.application.routes.url_helpers.request_path(notifiable_id)
    else
      '#'
    end
  end
end
