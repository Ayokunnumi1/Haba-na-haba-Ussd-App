class AddEventIdToInventories < ActiveRecord::Migration[7.1]
  def change
    add_column :inventories, :event_id, :integer
  end
end
