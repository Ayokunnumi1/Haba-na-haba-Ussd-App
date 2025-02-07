class ChangePrimaryKeyToUuidForBranches < ActiveRecord::Migration[7.1]
  def change
    # Remove foreign key constraints
    remove_foreign_key :branch_districts, :branches
    remove_foreign_key :family_beneficiaries, :branches
    remove_foreign_key :individual_beneficiaries, :branches
    remove_foreign_key :inventories, :branches
    remove_foreign_key :organization_beneficiaries, :branches
    remove_foreign_key :requests, :branches
    remove_foreign_key :users, :branches

    # Add the new primary key column if it doesn't exist
    unless column_exists?(:branches, :uuid)
      add_column :branches, :uuid, :uuid, default: 'gen_random_uuid()', null: false
    end

    # Update existing records to use the new uuid column
    Branch.reset_column_information
    Branch.find_each do |branch|
      branch.update_column(:uuid, SecureRandom.uuid) if branch.uuid.nil?
    end

    # Add temporary UUID columns
    add_column :branch_districts, :new_branch_id, :uuid
    add_column :family_beneficiaries, :new_branch_id, :uuid
    add_column :individual_beneficiaries, :new_branch_id, :uuid
    add_column :inventories, :new_branch_id, :uuid
    add_column :organization_beneficiaries, :new_branch_id, :uuid
    add_column :requests, :new_branch_id, :uuid
    add_column :users, :new_branch_id, :uuid

    # Update temporary UUID columns with corresponding UUIDs
    execute <<-SQL
      UPDATE branch_districts SET new_branch_id = (SELECT uuid FROM branches WHERE branches.id = branch_districts.branch_id);
      UPDATE family_beneficiaries SET new_branch_id = (SELECT uuid FROM branches WHERE branches.id = family_beneficiaries.branch_id);
      UPDATE individual_beneficiaries SET new_branch_id = (SELECT uuid FROM branches WHERE branches.id = individual_beneficiaries.branch_id);
      UPDATE inventories SET new_branch_id = (SELECT uuid FROM branches WHERE branches.id = inventories.branch_id);
      UPDATE organization_beneficiaries SET new_branch_id = (SELECT uuid FROM branches WHERE branches.id = organization_beneficiaries.branch_id);
      UPDATE requests SET new_branch_id = (SELECT uuid FROM branches WHERE branches.id = requests.branch_id);
      UPDATE users SET new_branch_id = (SELECT uuid FROM branches WHERE branches.id = users.branch_id);
    SQL

    # Remove old foreign key columns
    remove_column :branch_districts, :branch_id
    remove_column :family_beneficiaries, :branch_id
    remove_column :individual_beneficiaries, :branch_id
    remove_column :inventories, :branch_id
    remove_column :organization_beneficiaries, :branch_id
    remove_column :requests, :branch_id
    remove_column :users, :branch_id

    # Rename temporary UUID columns to original names
    rename_column :branch_districts, :new_branch_id, :branch_id
    rename_column :family_beneficiaries, :new_branch_id, :branch_id
    rename_column :individual_beneficiaries, :new_branch_id, :branch_id
    rename_column :inventories, :new_branch_id, :branch_id
    rename_column :organization_beneficiaries, :new_branch_id, :branch_id
    rename_column :requests, :new_branch_id, :branch_id
    rename_column :users, :new_branch_id, :branch_id

    # Remove the existing primary key
    remove_column :branches, :id, :bigint

    # Set the new primary key
    execute "ALTER TABLE branches ADD PRIMARY KEY (uuid);"

    # Add new foreign key references
    add_foreign_key :branch_districts, :branches, column: :branch_id, primary_key: :uuid
    add_foreign_key :family_beneficiaries, :branches, column: :branch_id, primary_key: :uuid
    add_foreign_key :individual_beneficiaries, :branches, column: :branch_id, primary_key: :uuid
    add_foreign_key :inventories, :branches, column: :branch_id, primary_key: :uuid
    add_foreign_key :organization_beneficiaries, :branches, column: :branch_id, primary_key: :uuid
    add_foreign_key :requests, :branches, column: :branch_id, primary_key: :uuid
    add_foreign_key :users, :branches, column: :branch_id, primary_key: :uuid
  end
end