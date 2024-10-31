class ModifyBranchesForManyDistricts < ActiveRecord::Migration[7.1]
  def change
    # Remove the existing district_id column from branches
    remove_column :branches, :district_id, :bigint

    # Create the join table for branches and districts
    create_table :branch_districts do |t|
      t.references :branch, null: false, foreign_key: true
      t.references :district, null: false, foreign_key: true

      t.timestamps
    end

    # Add a unique index to prevent duplicate associations
    add_index :branch_districts, [:branch_id, :district_id], unique: true
  end
end
