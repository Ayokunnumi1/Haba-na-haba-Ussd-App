class AddEventIdToRequests < ActiveRecord::Migration[7.1]
  def change
    add_column :requests, :event_id, :integer
  end
end
