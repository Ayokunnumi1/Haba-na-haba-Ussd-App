module FoodDonationModule
  extend SmsHelper
  def self.process_request(text, phone_number, _session)
    input_parts = text.split('*')
    request_name = input_parts[1]
    district_name = input_parts[2]
    county_name = input_parts[3]
    sub_county_name = input_parts[4]

    # Locate the district and branch
    selected_district = District.search_by_name(district_name).first
    selected_county = selected_district.counties.search_by_name(county_name).first
    selected_sub_county = selected_county.sub_counties.search_by_name(sub_county_name).first

    return 'END No matching district found.' if selected_district.nil?
    return 'END No matching county found.' if selected_county.nil?
    return 'END No matching sub county found.' if selected_sub_county.nil?

    puts "Selected district #{selected_district}"
    puts "Selected District: ID=#{selected_district.id}, Name=#{selected_district.name}"

    branch = Branch.joins(:districts).find_by(districts: { id: selected_district.id })

    return 'END No matching district found.' if branch.nil?

    # Create donation request
    Request.create(
      phone_number:,
      name: request_name,
      request_type: 'food_donation',
      district_id: selected_district.id,
      county_id: selected_county.id,
      sub_county_id: selected_sub_county.id,
      branch_id: branch.id
    )

    message = "Thank you for your donation we are reaching out to you shortly. Proceed to branch #{branch.name} in #{selected_district.name}"
    SmsHelper.send_sms(phone_number, message)
    'END Thank you for your donation we are reaching out to you shortly'
  end
end