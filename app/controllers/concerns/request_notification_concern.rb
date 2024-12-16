module RequestNotificationConcern
  extend ActiveSupport::Concern

  # Notify branch managers when a new request is created
  def notify_branch_managers(request, current_user)
    branch_managers = User.where(role: 'branch_manager', branch_id: request.branch_id)
      .where.not(id: current_user.id)

    branch_managers.each do |manager|
      Notification.create(
        user: manager,
        notifiable: request,
        message: 'A new request has been created in your branch.'
      )
    end
  end

  # Notify the user when their request is updated
  def notify_request_user(request, current_user)
    return if request.user_id.nil? || request.user_id == current_user.id

    user = User.find(request.user_id)

    Notification.create(
      user: user,
      notifiable: request,
      message: 'Your request has been updated.'
    )
  end
end
