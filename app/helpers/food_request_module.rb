module FoodRequestModule
  extend SmsHelper

  def self.process_request(text, phone_number, _session)
    input_parts = text.split('*')
    request_name = input_parts[1]
    district_name = input_parts[2]

    # Find the district by name
    selected_district = District.search_by_name(district_name).first || District.find_by(name: 'Default District')
    return 'END No matching district found.' unless selected_district

    # Find the branch associated with the district
    branch = Branch.joins(:districts).find_by(districts: { id: selected_district.id }) || Branch.find_by(name: 'Default Branch')
    return 'END No branch found for the selected district.' unless branch

    # Create a new request
    new_request = Request.new(
      phone_number:,
      name: request_name,
      request_type: 'food_request',
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
