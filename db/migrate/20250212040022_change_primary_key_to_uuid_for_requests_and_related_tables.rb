class ChangePrimaryKeyToUuidForRequestsAndRelatedTables < ActiveRecord::Migration[7.1]
  def up
    # Ensure the pgcrypto extension is enabled.
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')

    # Add a new UUID column to requests.
    add_column :requests, :new_id, :uuid, default: -> { "gen_random_uuid()" }, null: false
    add_index :requests, :new_id, unique: true

    # Populate new_id for any existing records.
    execute "UPDATE requests SET new_id = gen_random_uuid() WHERE new_id IS NULL"

    # For each table that references requests, add a new temporary UUID column.
    add_column :family_beneficiaries, :request_uuid, :uuid
    add_column :individual_beneficiaries, :request_uuid, :uuid
    add_column :inventories, :request_uuid, :uuid
    add_column :organization_beneficiaries, :request_uuid, :uuid

    # Populate the new UUID columns by joining with requests.
    execute <<-SQL.squish
      UPDATE family_beneficiaries
      SET request_uuid = requests.new_id
      FROM requests
      WHERE family_beneficiaries.request_id = requests.id
    SQL

    execute <<-SQL.squish
      UPDATE individual_beneficiaries
      SET request_uuid = requests.new_id
      FROM requests
      WHERE individual_beneficiaries.request_id = requests.id
    SQL

    execute <<-SQL.squish
      UPDATE inventories
      SET request_uuid = requests.new_id
      FROM requests
      WHERE inventories.request_id = requests.id
    SQL

    execute <<-SQL.squish
      UPDATE organization_beneficiaries
      SET request_uuid = requests.new_id
      FROM requests
      WHERE organization_beneficiaries.request_id = requests.id
    SQL

    # Remove the old foreign key constraints.
    remove_foreign_key :family_beneficiaries, :requests
    remove_foreign_key :individual_beneficiaries, :requests
    remove_foreign_key :inventories, :requests
    remove_foreign_key :organization_beneficiaries, :requests

    # Remove the old integer foreign key columns and rename the temporary columns.
    remove_column :family_beneficiaries, :request_id
    remove_column :individual_beneficiaries, :request_id
    remove_column :inventories, :request_id
    remove_column :organization_beneficiaries, :request_id

    rename_column :family_beneficiaries, :request_uuid, :request_id
    rename_column :individual_beneficiaries, :request_uuid, :request_id
    rename_column :inventories, :request_uuid, :request_id
    rename_column :organization_beneficiaries, :request_uuid, :request_id

    # Change the type of the new foreign key columns to UUID (if not already).
    change_column :family_beneficiaries, :request_id, :uuid
    change_column :individual_beneficiaries, :request_id, :uuid
    change_column :inventories, :request_id, :uuid
    change_column :organization_beneficiaries, :request_id, :uuid

    # Add new foreign key constraints referencing requests(new_id).
    add_foreign_key :family_beneficiaries, :requests, column: :request_id, primary_key: "new_id"
    add_foreign_key :individual_beneficiaries, :requests, column: :request_id, primary_key: "new_id"
    add_foreign_key :inventories, :requests, column: :request_id, primary_key: "new_id"
    add_foreign_key :organization_beneficiaries, :requests, column: :request_id, primary_key: "new_id"

    # Change the primary key on requests:
    # Drop the current primary key constraint.
    execute("ALTER TABLE requests DROP CONSTRAINT requests_pkey")
    # Add a new primary key constraint using the new UUID column.
    execute("ALTER TABLE requests ADD PRIMARY KEY (new_id)")

    # Remove the old integer id column and rename new_id to id.
    remove_column :requests, :id
    rename_column :requests, :new_id, :id

    # Repeat the process for inventories, individual_beneficiaries, family_beneficiaries, and organization_beneficiaries tables
    # Add a new UUID column to each table.
    add_column :inventories, :new_id, :uuid, default: -> { "gen_random_uuid()" }, null: false
    add_column :individual_beneficiaries, :new_id, :uuid, default: -> { "gen_random_uuid()" }, null: false
    add_column :family_beneficiaries, :new_id, :uuid, default: -> { "gen_random_uuid()" }, null: false
    add_column :organization_beneficiaries, :new_id, :uuid, default: -> { "gen_random_uuid()" }, null: false

    # Add indexes for the new UUID columns.
    add_index :inventories, :new_id, unique: true
    add_index :individual_beneficiaries, :new_id, unique: true
    add_index :family_beneficiaries, :new_id, unique: true
    add_index :organization_beneficiaries, :new_id, unique: true

    # Populate new_id for any existing records.
    execute "UPDATE inventories SET new_id = gen_random_uuid() WHERE new_id IS NULL"
    execute "UPDATE individual_beneficiaries SET new_id = gen_random_uuid() WHERE new_id IS NULL"
    execute "UPDATE family_beneficiaries SET new_id = gen_random_uuid() WHERE new_id IS NULL"
    execute "UPDATE organization_beneficiaries SET new_id = gen_random_uuid() WHERE new_id IS NULL"

    # Change the primary key on each table:
    # Drop the current primary key constraint.
    execute("ALTER TABLE inventories DROP CONSTRAINT inventories_pkey")
    execute("ALTER TABLE individual_beneficiaries DROP CONSTRAINT individual_beneficiaries_pkey")
    execute("ALTER TABLE family_beneficiaries DROP CONSTRAINT family_beneficiaries_pkey")
    execute("ALTER TABLE organization_beneficiaries DROP CONSTRAINT organization_beneficiaries_pkey")

    # Add a new primary key constraint using the new UUID column.
    execute("ALTER TABLE inventories ADD PRIMARY KEY (new_id)")
    execute("ALTER TABLE individual_beneficiaries ADD PRIMARY KEY (new_id)")
    execute("ALTER TABLE family_beneficiaries ADD PRIMARY KEY (new_id)")
    execute("ALTER TABLE organization_beneficiaries ADD PRIMARY KEY (new_id)")

    # Remove the old integer id columns and rename new_id to id.
    remove_column :inventories, :id
    remove_column :individual_beneficiaries, :id
    remove_column :family_beneficiaries, :id
    remove_column :organization_beneficiaries, :id

    rename_column :inventories, :new_id, :id
    rename_column :individual_beneficiaries, :new_id, :id
    rename_column :family_beneficiaries, :new_id, :id
    rename_column :organization_beneficiaries, :new_id, :id
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "Converting from UUID back to integer is not supported."
  end
end