class AddFoodTypeAndNameToRequests < ActiveRecord::Migration[7.1]
  def change
    add_column :requests, :food_type, :string
    add_column :requests, :food_name, :string
  end
end
