# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
User.create!(
  first_name: 'Super',
  last_name: 'Admin',
  email: 'superadmi5@example.com',
  phone_number: '+1234567890',
  role: 'super_admin',
  password: 'supersecurepassword5',
  password_confirmation: 'supersecurepassword5'
)


# db/seeds.rb

# Clear existing data to avoid duplication
Branch.destroy_all
County.destroy_all
District.destroy_all

# Seed data for districts and counties
district_data = [
  { name: 'Central District', counties: ['Central County 1', 'Central County 2', 'Central County 3'] },
  { name: 'Northern District', counties: ['Northern County 1', 'Northern County 2', 'Northern County 3'] },
  { name: 'Southern District', counties: ['Southern County 1', 'Southern County 2', 'Southern County 3'] },
  { name: 'Eastern District', counties: ['Eastern County 1', 'Eastern County 2', 'Eastern County 3'] },
  { name: 'Western District', counties: ['Western County 1', 'Western County 2', 'Western County 3'] }
]

# Create districts and associated counties
district_data.each do |district_info|
  district = District.find_or_create_by!(name: district_info[:name])
  puts "Created District: #{district.name}"

  # Create counties within each district
  district_info[:counties].each do |county_name|
    county = County.find_or_create_by!(name: county_name, district: district)
    puts "  Created County: #{county.name} in District: #{district.name}"
  end
end

# Create branches with associations to districts and counties
branch_data = [
  { name: "Branch 1", phone_number: "1234567890", district_name: "Central District", county_name: "Central County 1" },
  { name: "Branch 2", phone_number: "2345678901", district_name: "Northern District", county_name: "Northern County 2" },
  { name: "Branch 3", phone_number: "3456789012", district_name: "Southern District", county_name: "Southern County 3" }
]

branch_data.each do |branch_info|
  district = District.find_by(name: branch_info[:district_name])
  county = County.find_by(name: branch_info[:county_name], district: district)

  if district && county
    Branch.find_or_create_by!(
      name: branch_info[:name],
      phone_number: branch_info[:phone_number],
      district: district,
      county: county
    )
    puts "Created Branch: #{branch_info[:name]} in #{district.name} - #{county.name}"
  else
    puts "Could not create Branch: #{branch_info[:name]} - District or County not found."
  end
end

puts "Seeded districts, counties, and branches successfully."
