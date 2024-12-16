class RemoveColumnsFromInventories < ActiveRecord::Migration[7.1]
  def change
    remove_column :inventories, :account_number, :string
    remove_column :inventories, :parish, :string
    remove_column :inventories, :village_address, :string
  end
end
