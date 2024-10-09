class CreateInventories < ActiveRecord::Migration[7.1]
  def change
    create_table :inventories do |t|
      t.string :donor_name
      t.string :donor_type
      t.date :collection_date
      t.string :food_name
      t.date :expire_date
      t.references :district, null: false, foreign_key: true
      t.references :county, null: false, foreign_key: true
      t.references :subcounty, null: false, foreign_key: true
      t.string :village_address
      t.string :residence_address
      t.string :phone_number
      t.string :parish
      t.decimal :amount
      t.string :head_of_institution
      t.string :registration_no
      t.references :request, null: false, foreign_key: true

      t.timestamps
    end
  end
end
