class AddNewColumnsToInventories < ActiveRecord::Migration[7.1]
  def change
    add_column :inventories, :donation_type, :string
    add_column :inventories, :food_quantity, :integer
    add_column :inventories, :food_type, :string
    add_column :inventories, :place_of_collection, :string
    add_column :inventories, :cost_of_food, :decimal
    add_column :inventories, :cloth_type, :string
    add_column :inventories, :other_items_condition, :string
    add_column :inventories, :other_items_name, :string
    add_column :inventories, :other_items_quantity, :integer
  end
end
