class UpdateInventories < ActiveRecord::Migration[7.1]
  def change
    change_column_null :inventories, :request_id, true

    add_reference :inventories, :branch, foreign_key: true, null: true

    add_column :inventories, :collection_amount, :decimal
  end
end
