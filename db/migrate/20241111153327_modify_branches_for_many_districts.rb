class ModifyBranchesForManyDistricts < ActiveRecord::Migration[7.1]
  def change
    remove_column :branches, :district_id, :bigint

    create_table :branch_districts do |t|
      t.references :branch, null: false, foreign_key: true
      t.references :district, null: false, foreign_key: true

      t.timestamps
    end

    add_index :branch_districts, [:branch_id, :district_id], unique: true
  end
end
