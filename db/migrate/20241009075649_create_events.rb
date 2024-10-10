class CreateEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :events do |t|
      t.string :name
      t.datetime :start_date
      t.datetime :end_date
      t.references :district, null: false, foreign_key: true
      t.references :county, null: false, foreign_key: true
      t.references :sub_county, null: false, foreign_key: true

      t.timestamps
    end
  end
end
