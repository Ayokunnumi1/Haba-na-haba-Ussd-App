module NotifiableRequest
    extend ActiveSupport::Concern
  
    included do
      after_create :notify_all_users
      after_update :notify_volunteer_if_assigned
    end
  
    private
  
    # Notify all users when a new request is created
    def notify_all_users
      User.each do |user|
        ActionCable.server.broadcast(
          "notifications_user",
          {
            message: "New request created: #{name}",
            request_id: id
          }
        )
      end
    end
  
    # Notify only the assigned volunteer when a request is updated
    def notify_volunteer_if_assigned
      return unless user_id_previously_changed? && user.present?
  
      ActionCable.server.broadcast(
        "notifications_user",
        {
          message: "You have been assigned to request: #{name}",
          request_id: id
        }
        )
    end
end
  