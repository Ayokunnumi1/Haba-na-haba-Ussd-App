class CreateBranches < ActiveRecord::Migration[7.1]
  def change
    create_table :branches do |t|
      t.string :name
      t.string :phone_number
      t.references :district, null: false, foreign_key: true
      t.references :county, null: false, foreign_key: true

      t.timestamps
    end
  end
end
