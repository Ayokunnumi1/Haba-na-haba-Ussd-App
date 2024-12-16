class AddOrganizationAndFamilyDetailsToInventories < ActiveRecord::Migration[7.1]
  def change
    add_column :inventories, :organization_name, :string
    add_column :inventories, :organization_contact_person, :string
    add_column :inventories, :organization_contact_phone, :string
    add_column :inventories, :family_name, :string
    add_column :inventories, :family_member_count, :integer
  end
end
