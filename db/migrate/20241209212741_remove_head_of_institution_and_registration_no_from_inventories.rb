class RemoveHeadOfInstitutionAndRegistrationNoFromInventories < ActiveRecord::Migration[7.1]
  def change
    remove_column :inventories, :head_of_institution, :string
    remove_column :inventories, :registration_no, :string
  end
end
