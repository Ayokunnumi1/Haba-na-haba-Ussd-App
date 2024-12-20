require 'faker'

# Reset Faker unique constraints
Faker::UniqueGenerator.clear
Faker::Config.random = Random.new

# Seed 100 Districts
districts = 100.times.map do
  District.find_or_create_by!(name: "#{Faker::Address.unique.city} District")
end
puts "Seeded #{districts.count} districts."

# Seed Counties with District Associations
counties = 100.times.map do
  County.create!(
    name: "#{Faker::Address.unique.city} County",
    district: districts.sample
  )
end
puts "Seeded #{counties.count} counties."

# Seed Sub-counties with County Associations
sub_counties = 100.times.map do
  SubCounty.create!(
    name: "#{Faker::Address.community} Sub-county",
    county: counties.sample
  )
end
puts "Seeded #{sub_counties.count} sub-counties."

# Seed Branches with District Associations
branches = 100.times.map do
  branch_district_ids = districts.sample(rand(1..5)) # Each branch is associated with 1 to 5 districts
  branch = Branch.create!(
    name: "#{Faker::Address.unique.city} Branch",
    phone_number: Faker::PhoneNumber.cell_phone_in_e164,
    district_ids: branch_district_ids.map(&:id) # Ensure districts are associated
  )
  branch
end
puts "Seeded #{branches.count} branches with district associations."

# Seed Users
roles = ["super_admin", "admin", "branch_manager", "volunteer"]
users = 100.times.map do
  User.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    phone_number: Faker::PhoneNumber.cell_phone_in_e164,
    role: roles.sample,
    email: Faker::Internet.unique.email,
    password: 'password',
    gender: Faker::Gender.binary_type,
    location: Faker::Address.unique.city,
    branch: branches.sample
  )
end
puts "Seeded #{users.count} users."

# Seed Requests
request_types = ["Food Request", "Food donation", "Other donations"]
requests = 100.times.map do
  Request.create!(
    name: Faker::Name.name,
    phone_number: Faker::PhoneNumber.cell_phone_in_e164,
    request_type: request_types.sample,
    residence_address: Faker::Address.street_address,
    village: Faker::Address.community,
    parish: Faker::Address.community,
    is_selected: [true, false].sample,
    district: districts.sample,
    county: counties.sample,
    sub_county: sub_counties.sample,
    branch: branches.sample,
    user: users.sample
  )
end
puts "Seeded #{requests.count} requests."

# Seed Inventories
donor_types = ["individual_donor", "family_donor", "organization_donor"]
donation_types = ["food", "cash", "cloth", "other_items"]
food_types = ["fresh_food", "dry_food", "others"]

100.times do
  donation_type = donation_types.sample
  inventory_attributes = {
    donor_name: Faker::Name.name,
    donor_type: donor_types.sample,
    collection_date: Faker::Date.backward(days: 30),
    district: districts.sample,
    county: counties.sample,
    sub_county: sub_counties.sample,
    residence_address: Faker::Address.street_address,
    phone_number: Faker::PhoneNumber.cell_phone_in_e164,
    request: requests.sample,
    branch: branches.sample,
    place_of_collection: Faker::Address.community
  }
  
  case donation_type
  when "food"
    inventory_attributes.merge!(
      donation_type: "food",
      food_name: Faker::Food.ingredient,
      expire_date: Faker::Date.forward(days: 30),
      food_quantity: Faker::Number.between(from: 1, to: 100),
      food_type: food_types.sample,
      cost_of_food: Faker::Commerce.price(range: 1..100.0)
    )
  when "cash"
    inventory_attributes.merge!(
      donation_type: "cash",
      amount: Faker::Commerce.price(range: 1..1000.0),
      collection_amount: Faker::Commerce.price(range: 1..1000.0)
    )
  when "cloth"
    inventory_attributes.merge!(
      donation_type: "cloth",
      cloth_condition: ["new", "good_condition", "worn"].sample,
      cloth_name: Faker::Commerce.product_name,
      cloth_size: ["small", "medium", "large", "xtra_large"].sample,
      cloth_quantity: Faker::Number.between(from: 1, to: 50),
      cloth_type: ["Male", "Female", "Others"].sample
    )
  when "other_items"
    inventory_attributes.merge!(
      donation_type: "other_items",
      other_items_condition: ["new", "good_condition", "worn"].sample,
      other_items_name: Faker::Commerce.product_name,
      other_items_quantity: Faker::Number.between(from: 1, to: 50)
    )
  end
  Inventory.create!(inventory_attributes)
end

puts "Seeded #{Inventory.count} inventories."

puts "Database seeded successfully with 100 districts and associated data!"