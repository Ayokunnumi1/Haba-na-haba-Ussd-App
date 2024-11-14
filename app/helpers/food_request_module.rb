module FoodRequestModule
  def self.process_request(text, phone_number, _session)
    all_districts = District.all
    puts 'All Districts:'
    all_districts.each do |district|
      puts "District ID: #{district.id}, Name: #{district.name}"
    end

    input_parts = text.split('*')
    request_name = text.split[1]
    district_name = input_parts[2]
    county_name = input_parts[3]
    sub_county_name = input_parts[4]

    puts "district name #{district_name}"

    selected_district = District.search_by_name(district_name).first
    selected_county = County.search_by_name(county_name).first
    selected_sub_county = SubCounty.search_by_name(sub_county_name).first

    return 'END No matching district found.' if selected_district.nil?

    puts "Selected district #{selected_district}"
    puts "Selected county #{selected_county}"
    puts "Selected sub county #{selected_sub_county}"
    puts "Selected District: ID=#{selected_district.id}, Name=#{selected_district.name}"
    puts "Selected District: ID=#{selected_county.id}, Name=#{selected_county.name}"
    puts "Selected District: ID=#{selected_sub_county.id}, Name=#{selected_sub_county.name}"

    branch = Branch.joins(:districts).find_by(districts: { id: selected_district.id })
    branch_name = branch.name
    new_request = Request.create(
      phone_number:,
      name: request_name,
      request_type: 'Food',
      district_id: selected_district.id,
      county_id: selected_county.id,
      sub_county_id: selected_sub_county.id,
      branch_id: branch.id
    )

    if new_request.save(validate: false)
      "END We are processing your request and will contact you shortly. Proceed to the branch #{branch_name} in #{selected_district.name} District."
    else
      puts "Request creation failed: #{new_request.errors.full_messages.join(', ')}"
      'END There was an issue processing your request. Please try again later.'
    end
  end
end
