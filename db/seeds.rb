# db/seeds.rb

require 'faker'

# Seed Districts
district_names = ['Wakiso District', 'Mukono District', 'Jinja District', 'Iganga District', 'Soroti District', 'Katakwi District', 'Mbale District', 'Bududa District', 'Kakumiro District', 'Kyankwanzi District']
districts = district_names.map { |name| District.find_or_create_by!(name: name) }
puts "Seeded #{districts.count} districts."

# Seed Counties with District Associations
county_data = [
  { name: 'Busiro', district: districts[0] },
  { name: 'Mukono County', district: districts[1] },
  { name: 'Butembe', district: districts[2] },
  { name: 'Kigulu', district: districts[3] },
  { name: 'Soroti County', district: districts[4] },
  { name: 'Usuk', district: districts[5] },
  { name: 'Bungokho', district: districts[6] },
  { name: 'Manjiya', district: districts[7] },
  { name: 'Bugangaizi', district: districts[8] },
  { name: 'Kiboga', district: districts[9] }
]
counties = county_data.map { |data| County.find_or_create_by!(data) }
puts "Seeded #{counties.count} counties."

# Seed Sub-counties with County Associations
sub_county_data = [
  { name: 'Namayumba', county: counties[0] },
  { name: 'Goma', county: counties[1] },
  { name: 'Budondo', county: counties[2] },
  { name: 'Nakigo', county: counties[3] },
  { name: 'Arapai', county: counties[4] },
  { name: 'Kapujan', county: counties[5] },
  { name: 'Busiu', county: counties[6] },
  { name: 'Bushika', county: counties[7] },
  { name: 'Kakindo', county: counties[8] },
  { name: 'Gayaza', county: counties[9] }
]
sub_counties = sub_county_data.map { |data| SubCounty.find_or_create_by!(data) }
puts "Seeded #{sub_counties.count} sub-counties."

# Seed Branches without direct district assignment
branch_data = [
  { name: 'Busiro Branch', phone_number: '256700111111', county: counties[0] },
  { name: 'Goma Branch', phone_number: '256700222222', county: counties[1] },
  { name: 'Budondo Branch', phone_number: '256700333333', county: counties[2] },
  { name: 'Nakigo Branch', phone_number: '256700444444', county: counties[3] },
  { name: 'Arapai Branch', phone_number: '256700555555', county: counties[4] },
  { name: 'Kapujan Branch', phone_number: '256700666666', county: counties[5] },
  { name: 'Busiu Branch', phone_number: '256700777777', county: counties[6] },
  { name: 'Bushika Branch', phone_number: '256700888888', county: counties[7] },
  { name: 'Kakindo Branch', phone_number: '256700999999', county: counties[8] },
  { name: 'Gayaza Branch', phone_number: '256701000000', county: counties[9] }
]

branches = branch_data.map do |data|
  Branch.find_or_create_by!(name: data[:name], phone_number: data[:phone_number], county: data[:county])
end
puts "Seeded #{branches.count} branches."

# Associate branches with districts through BranchDistrict join table
branch_district_data = [
  { branch: branches[0], district: districts[0] },
  { branch: branches[1], district: districts[1] },
  { branch: branches[2], district: districts[2] },
  { branch: branches[3], district: districts[3] },
  { branch: branches[4], district: districts[4] },
  { branch: branches[5], district: districts[5] },
  { branch: branches[6], district: districts[6] },
  { branch: branches[7], district: districts[7] },
  { branch: branches[8], district: districts[8] },
  { branch: branches[9], district: districts[1] }
]

branch_district_data.each do |data|
  BranchDistrict.find_or_create_by!(branch: data[:branch], district: data[:district])
end
puts "Seeded branch-district associations."

# Seed Users
roles = ["super_admin", "admin", "branch_manager", "volunteer"]
10.times do
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
puts "Seeded users."

# Seed Requests
request_types = ["food", "donation"]
10.times do
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
    user: User.all.sample
  )
end
puts "Seeded requests."

# Seed Inventories
donor_types = ["fresh_food", "dry_food", "clothing", "cash", "other"]
10.times do
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
    request: Request.all.sample
  )
end
puts "Seeded inventories."

puts "Database seeded successfully!"
