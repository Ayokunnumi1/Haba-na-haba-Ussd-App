class AddFieldsToInventories < ActiveRecord::Migration[7.1]
  def change
    add_column :inventories, :account_number, :string
    add_column :inventories, :cloth_condition, :string
    add_column :inventories, :cloth_name, :string
    add_column :inventories, :cloth_size, :string
    add_column :inventories, :cloth_quantity, :integer    
  end
end
