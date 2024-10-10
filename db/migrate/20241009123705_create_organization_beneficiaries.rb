class CreateOrganizationBeneficiaries < ActiveRecord::Migration[7.1]
  def change
    create_table :organization_beneficiaries do |t|
      t.text :organization_name
      t.integer :male
      t.integer :female
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
      t.text :registration_no
      t.text :organization_no
      t.text :directors_name
      t.text :head_of_institution
      t.integer :number_of_meals_home
      t.text :basic_FEH
      t.references :request, null: false, foreign_key: true

      t.timestamps
    end
  end
end
