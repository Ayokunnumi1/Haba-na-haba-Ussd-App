class ConvertUsersToUuid < ActiveRecord::Migration[7.1]
  def up
    # 1. Ensure the pgcrypto extension is enabled.
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')

    # 2. Add a new UUID column to users.
    add_column :users, :new_id, :uuid, default: -> { "gen_random_uuid()" }, null: false

    add_index :users, :new_id, unique: true

    # (If data) Populate new_id for any existing records.
    execute "UPDATE users SET new_id = gen_random_uuid() WHERE new_id IS NULL"

    # 3. For each table that references users, add a new temporary UUID column.
    # Here’s an example for three referencing tables.
    add_column :event_users, :user_uuid, :uuid
    add_column :notifications, :user_uuid, :uuid
    add_column :requests, :user_uuid, :uuid

    # 4. Populate the new UUID columns by joining with users.
    execute <<-SQL.squish
      UPDATE event_users
      SET user_uuid = users.new_id
      FROM users
      WHERE event_users.user_id = users.id
    SQL

    execute <<-SQL.squish
      UPDATE notifications
      SET user_uuid = users.new_id
      FROM users
      WHERE notifications.user_id = users.id
    SQL

    execute <<-SQL.squish
      UPDATE requests
      SET user_uuid = users.new_id
      FROM users
      WHERE requests.user_id = users.id
    SQL

    # 5. Remove the old foreign key constraints.
    remove_foreign_key :event_users, :users
    remove_foreign_key :notifications, :users
    remove_foreign_key :requests, :users

    # 6. Remove the old integer foreign key columns and rename the temporary columns.
    remove_column :event_users, :user_id
    remove_column :notifications, :user_id
    remove_column :requests, :user_id

    rename_column :event_users, :user_uuid, :user_id
    rename_column :notifications, :user_uuid, :user_id
    rename_column :requests, :user_uuid, :user_id

    # 7. Change the type of the new foreign key columns to UUID (if not already).
    change_column :event_users, :user_id, :uuid
    change_column :notifications, :user_id, :uuid
    change_column :requests, :user_id, :uuid

    # . Add new foreign 8key constraints referencing users(new_id).
    add_foreign_key :event_users, :users, column: :user_id, primary_key: "new_id"
    add_foreign_key :notifications, :users, column: :user_id, primary_key: "new_id"
    add_foreign_key :requests, :users, column: :user_id, primary_key: "new_id"

    # 9. Change the primary key on users:
    #    a. Drop the current primary key constraint.
    execute("ALTER TABLE users DROP CONSTRAINT users_pkey")
    #    b. Add a new primary key constraint using the new UUID column.
    execute("ALTER TABLE users ADD PRIMARY KEY (new_id)")

    # 10. Remove the old integer id column and rename new_id to id.
    remove_column :users, :id
    rename_column :users, :new_id, :id
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "Converting from UUID back to integer is not supported."
  end
end
