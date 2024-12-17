class AddAmountToRequests < ActiveRecord::Migration[7.1]
  def change
    add_column :requests, :amount, :integer
  end
end
