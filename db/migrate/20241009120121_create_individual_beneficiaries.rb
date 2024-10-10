class CreateIndividualBeneficiaries < ActiveRecord::Migration[7.1]
  def change
    create_table :individual_beneficiaries do |t|
      t.string :name
      t.integer :age
      t.string :gender
      t.string :residence_address
      t.string :village
      t.string :parish
      t.string :phone_number
      t.string :case_name
      t.text :case_description
      t.string :fathers_name
      t.string :mothers_name
      t.string :sur_name
      t.references :district, null: false, foreign_key: true
      t.references :county, null: false, foreign_key: true
      t.references :sub_county, null: false, foreign_key: true
      t.references :request, null: false, foreign_key: true

      t.timestamps
    end
  end
end
