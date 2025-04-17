class ConvertEventsToUuid < ActiveRecord::Migration[7.1]
  def up
    # 1. Add a new UUID column to events with a default value
    add_column :events, :new_id, :uuid, default: -> { "gen_random_uuid()" }, null: false
    add_index :events, :new_id, unique: true

    # 2. Update event_users (which has a foreign key to events)
    #    a. Add a temporary UUID column to event_users
    add_column :event_users, :event_uuid, :uuid

    #    b. Populate event_uuid from events.new_id (join on the old integer id)
    execute <<-SQL.squish
      UPDATE event_users
      SET event_uuid = events.new_id
      FROM events
      WHERE event_users.event_id = events.id
    SQL

    #    c. Remove the old foreign key and column from event_users
    remove_foreign_key :event_users, :events
    remove_column :event_users, :event_id

    #    d. Rename the temporary column to event_id and change its type to uuid
    rename_column :event_users, :event_uuid, :event_id
    change_column :event_users, :event_id, :uuid

    #    e. Re-add the foreign key constraint, referencing events(new_id)
    add_foreign_key :event_users, :events, column: :event_id, primary_key: "new_id"

    # 3. Change the primary key on events:
    #    a. Drop the existing primary key constraint
    execute("ALTER TABLE events DROP CONSTRAINT events_pkey")

    #    b. Add a new primary key constraint on new_id
    execute("ALTER TABLE events ADD PRIMARY KEY (new_id)")

    # 4. Remove the old integer id column and rename new_id to id
    remove_column :events, :id
    rename_column :events, :new_id, :id
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "Converting events to UUID cannot be reverted."
  end
end
