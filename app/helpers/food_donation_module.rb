module FoodDonationModule
  extend SmsHelper
  def self.process_request(text, phone_number, _session)
    input_parts = text.split('*')
    request_name = input_parts[1]
    district_name = input_parts[2]
    food_type = input_parts[3]
    food_name = input_parts[4]
    donation_amount = input_parts[5]

    # Locate the district and branch
    selected_district = District.search_by_name(district_name).first || District.find_by(name: 'Default District')
    return 'END No matching district found.' unless selected_district
  

    branch = Branch.joins(:districts).find_by(districts: { id: selected_district.id }) || Branch.find_by(name: 'Haba na Haba Branch')
    return 'END No matching district found.' unless selected_district

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
