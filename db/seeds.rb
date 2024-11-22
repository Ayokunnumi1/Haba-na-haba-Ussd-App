require 'faker'

# Seed 100 Districts
districts = 100.times.map do
  District.find_or_create_by!(name: "#{Faker::Address.unique.city} District")
end
puts "Seeded #{districts.count} districts."

# Seed Counties with District Associations
counties = 100.times.map do
  County.create!(
    name: Faker::Address.city,
    district: districts.sample
  )
end
puts "Seeded #{counties.count} counties."

# Seed Sub-counties with County Associations
sub_counties = 100.times.map do
  SubCounty.create!(
    name: Faker::Address.community,
    county: counties.sample
  )
end
puts "Seeded #{sub_counties.count} sub-counties."

# Seed Branches
branches = 100.times.map do
  Branch.create!(
    name: "#{Faker::Address.city} Branch",
    phone_number: Faker::PhoneNumber.cell_phone_in_e164,
  )
end
puts "Seeded #{branches.count} branches."

# Associate branches with districts through BranchDistrict join table
branch_district_data = 100.times.map do
  BranchDistrict.create!(
    branch: branches.sample,
    district: districts.sample
  )
end
puts "Seeded #{branch_district_data.count} branch-district associations."

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
    branch: branches.sample
  )
end
puts "Seeded #{users.count} users."

# Seed Requests
request_types = ["food", "donation"]
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
donor_types = ["fresh_food", "dry_food", "clothing", "cash", "other"]
inventories = 100.times.map do
  Inventory.create!(
    donor_name: Faker::Name.name,
    donor_type: donor_types.sample,
    collection_date: Faker::Date.backward(days: 30),
    food_name: Faker::Food.ingredient,
    expire_date: Faker::Date.forward(days: 90),
    district: districts.sample,
    county: counties.sample,
    sub_county: sub_counties.sample,
    village_address: Faker::Address.community,
    residence_address: Faker::Address.street_address,
    phone_number: Faker::PhoneNumber.cell_phone_in_e164,
    parish: Faker::Address.community,
    amount: Faker::Number.decimal(l_digits: 2, r_digits: 2),
    head_of_institution: Faker::Name.name,
    registration_no: Faker::Number.unique.number(digits: 8),
    request: requests.sample
  )
end
puts "Seeded #{inventories.count} inventories."

puts "Database seeded successfully with 100 districts and associated data!"
