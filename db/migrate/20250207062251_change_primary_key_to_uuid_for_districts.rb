class ChangePrimaryKeyToUuidForDistricts < ActiveRecord::Migration[7.1]
  def change
    # Remove foreign key constraints
    remove_foreign_key :branch_districts, :districts
    remove_foreign_key :counties, :districts
    remove_foreign_key :events, :districts
    remove_foreign_key :family_beneficiaries, :districts
    remove_foreign_key :individual_beneficiaries, :districts
    remove_foreign_key :inventories, :districts
    remove_foreign_key :organization_beneficiaries, :districts
    remove_foreign_key :requests, :districts

    # Add temporary UUID columns
    add_column :branch_districts, :new_district_id, :uuid
    add_column :counties, :new_district_id, :uuid
    add_column :events, :new_district_id, :uuid
    add_column :family_beneficiaries, :new_district_id, :uuid
    add_column :individual_beneficiaries, :new_district_id, :uuid
    add_column :inventories, :new_district_id, :uuid
    add_column :organization_beneficiaries, :new_district_id, :uuid
    add_column :requests, :new_district_id, :uuid

    # Update temporary UUID columns with corresponding UUIDs
    execute(<<~SQL)
      UPDATE branch_districts SET new_district_id = CAST(CONCAT('00000000-0000-0000-0000-', LPAD(TO_HEX(districts.id), 12, '0')) AS uuid)
      FROM districts
      WHERE districts.id = branch_districts.district_id;
      
      UPDATE counties SET new_district_id = CAST(CONCAT('00000000-0000-0000-0000-', LPAD(TO_HEX(districts.id), 12, '0')) AS uuid)
      FROM districts
      WHERE districts.id = counties.district_id;
      
      UPDATE events SET new_district_id = CAST(CONCAT('00000000-0000-0000-0000-', LPAD(TO_HEX(districts.id), 12, '0')) AS uuid)
      FROM districts
      WHERE districts.id = events.district_id;
      
      UPDATE family_beneficiaries SET new_district_id = CAST(CONCAT('00000000-0000-0000-0000-', LPAD(TO_HEX(districts.id), 12, '0')) AS uuid)
      FROM districts
      WHERE districts.id = family_beneficiaries.district_id;
      
      UPDATE individual_beneficiaries SET new_district_id = CAST(CONCAT('00000000-0000-0000-0000-', LPAD(TO_HEX(districts.id), 12, '0')) AS uuid)
      FROM districts
      WHERE districts.id = individual_beneficiaries.district_id;
      
      UPDATE inventories SET new_district_id = CAST(CONCAT('00000000-0000-0000-0000-', LPAD(TO_HEX(districts.id), 12, '0')) AS uuid)
      FROM districts
      WHERE districts.id = inventories.district_id;
      
      UPDATE organization_beneficiaries SET new_district_id = CAST(CONCAT('00000000-0000-0000-0000-', LPAD(TO_HEX(districts.id), 12, '0')) AS uuid)
      FROM districts
      WHERE districts.id = organization_beneficiaries.district_id;
      
      UPDATE requests SET new_district_id = CAST(CONCAT('00000000-0000-0000-0000-', LPAD(TO_HEX(districts.id), 12, '0')) AS uuid)
      FROM districts
      WHERE districts.id = requests.district_id;
    SQL

    # Remove old foreign key columns
    remove_column :branch_districts, :district_id
    remove_column :counties, :district_id
    remove_column :events, :district_id
    remove_column :family_beneficiaries, :district_id
    remove_column :individual_beneficiaries, :district_id
    remove_column :inventories, :district_id
    remove_column :organization_beneficiaries, :district_id
    remove_column :requests, :district_id

    # Rename temporary UUID columns to original names
    rename_column :branch_districts, :new_district_id, :district_id
    rename_column :counties, :new_district_id, :district_id
    rename_column :events, :new_district_id, :district_id
    rename_column :family_beneficiaries, :new_district_id, :district_id
    rename_column :individual_beneficiaries, :new_district_id, :district_id
    rename_column :inventories, :new_district_id, :district_id
    rename_column :organization_beneficiaries, :new_district_id, :district_id
    rename_column :requests, :new_district_id, :district_id

    # Add the new primary key column if it doesn't exist
    unless column_exists?(:districts, :uuid)
      add_column :districts, :uuid, :uuid, default: 'gen_random_uuid()', null: false
    end

    # Update existing records to use the new uuid column
    District.reset_column_information
    District.find_each do |district|
      district.update_column(:uuid, SecureRandom.uuid) if district.uuid.nil?
    end

    # Remove the existing primary key
    remove_column :districts, :id, :bigint

    # Set the new primary key
    execute "ALTER TABLE districts ADD PRIMARY KEY (uuid);"

    # Add new foreign key references
    add_foreign_key :branch_districts, :districts, column: :district_id, primary_key: :uuid
    add_foreign_key :counties, :districts, column: :district_id, primary_key: :uuid
    add_foreign_key :events, :districts, column: :district_id, primary_key: :uuid
    add_foreign_key :family_beneficiaries, :districts, column: :district_id, primary_key: :uuid
    add_foreign_key :individual_beneficiaries, :districts, column: :district_id, primary_key: :uuid
    add_foreign_key :inventories, :districts, column: :district_id, primary_key: :uuid
    add_foreign_key :organization_beneficiaries, :districts, column: :district_id, primary_key: :uuid
    add_foreign_key :requests, :districts, column: :district_id, primary_key: :uuid
  end
end