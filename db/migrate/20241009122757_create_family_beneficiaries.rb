class CreateFamilyBeneficiaries < ActiveRecord::Migration[7.1]
  def change
    create_table :family_beneficiaries do |t|
      t.integer :family_members
      t.integer :male
      t.integer :female
      t.integer :children
      t.text :adult_age_range
      t.text :children_age_range
      t.references :district, null: false, foreign_key: true
      t.references :county, null: false, foreign_key: true
      t.references :sub_county, null: false, foreign_key: true
      t.text :residence_address
      t.text :village
      t.text :parish
      t.text :phone_number
      t.text :case_name
      t.text :case_description
      t.text :fathers_name
      t.text :mothers_name
      t.text :fathers_occupation
      t.text :mothers_occupation
      t.integer :number_of_meals_home
      t.integer :number_of_meals_school
      t.text :basic_FEH
      t.text :basic_FES
      t.references :request, null: false, foreign_key: true

      t.timestamps
    end
  end
end
