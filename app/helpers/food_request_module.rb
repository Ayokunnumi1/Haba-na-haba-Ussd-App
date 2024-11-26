module FoodRequestModule
  extend SmsHelper

  def self.process_request(text, phone_number, _session)
    input_parts = text.split('*')
    request_name = input_parts[1]
    district_name = input_parts[2]
    county_name = input_parts[3]
    sub_county_name = input_parts[4]

    # Find the district by name
    selected_district = District.search_by_name(district_name).first
    return 'END No matching district found.' unless selected_district

    # Find the county within the district
    selected_county = selected_district.counties.search_by_name(county_name).first
    return 'END No matching county found for the selected district.' unless selected_county

    # Find the sub-county within the county
    selected_sub_county = selected_county.sub_counties.search_by_name(sub_county_name).first    
    return 'END No matching sub-county found for the selected county.' unless selected_sub_county

    # Find the branch associated with the district
    branch = Branch.joins(:districts).find_by(districts: { id: selected_district.id })
    return 'END No branch found for the selected district.' unless branch

    branch_name = branch.name

    # Create a new request
    new_request = Request.new(
      phone_number: ,
      name: request_name,
      request_type: 'Food',
      district_id: selected_district.id,
      county_id: selected_county.id,
      sub_county_id: selected_sub_county.id,
      branch_id: branch.id
    )

    if new_request.save(validate: false)
      message = "We are processing your request and will contact you shortly. Proceed to the branch #{branch_name} in #{selected_district.name} District."
      SmsHelper.send_sms(phone_number, message)
      "END #{message}"
    else
      puts "Request creation failed: #{new_request.errors.full_messages.join(', ')}"
      'END There was an issue processing your request. Please try again later.'
    end
  end
end
