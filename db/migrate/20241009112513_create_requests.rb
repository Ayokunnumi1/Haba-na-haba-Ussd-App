class CreateRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :requests do |t|
      t.string :name
      t.string :phone_number
      t.string :request_type
      t.string :residence_address
      t.string :village
      t.string :parish
      t.boolean :is_selected
      t.references :district, null: false, foreign_key: true
      t.references :county, null: false, foreign_key: true
      t.references :sub_county, null: false, foreign_key: true
      t.references :branch, null: false, foreign_key: true
      t.references :user, null: true, foreign_key: true

      t.timestamps
    end
  end
end
