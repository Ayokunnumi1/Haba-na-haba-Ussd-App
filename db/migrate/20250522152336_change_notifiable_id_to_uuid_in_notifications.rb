class ChangeNotifiableIdToUuidInNotifications < ActiveRecord::Migration[7.1]
  def change
    # First, add a new UUID column
    add_column :notifications, :uuid_notifiable_id, :uuid

    # Update existing records (this might take a while if you have many notifications)
    Notification.reset_column_information
    Notification.find_each do |notification|
      if notification.notifiable_type == 'Request'
        request = Request.find_by(id: notification.notifiable_id)
        notification.update(uuid_notifiable_id: request.uuid) if request
      end
    end

    # Remove the old column and rename the new one
    remove_column :notifications, :notifiable_id
    rename_column :notifications, :uuid_notifiable_id, :notifiable_id
  end
end
