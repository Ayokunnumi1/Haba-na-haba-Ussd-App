# filepath: db/migrate/20250213000000_change_primary_key_to_uuid_for_branch_districts.rb
class ChangePrimaryKeyToUuidForBranchDistricts < ActiveRecord::Migration[7.1]
  def change
    # Remove the existing primary key
    remove_column :branch_districts, :id

    # Add a new UUID primary key
    add_column :branch_districts, :id, :uuid, default: 'gen_random_uuid()', null: false, primary_key: true
  end
end