module FoodDonationModule
  extend SmsHelper

  # Determine the request type based on user input
  FOOD_DONATION_TYPE_MAP = {
    '1' => 'Fresh Food',
    '2' => 'Dry Food'
  }.freeze

  # Map the donation type input to human-readable values
  FOOD_DONATION_TYPE_HUMAN_READABLE_MAP = {
    '1' => 'Fresh Food',
    '2' => 'Dry Food'
  }.freeze

  def self.process_request(text, phone_number, _session)
    input_parts = text.split('*')
    request_name = input_parts[1]
    district_name = input_parts[2]
    food_type = input_parts[3]
    food_name = input_parts[4]
    donation_amount = input_parts[5]

    request_type = FOOD_DONATION_TYPE_MAP[donation_type_input]
    return 'END Invalid donation type selected.' if request_type.nil?

    donation_type_human_readable = FOOD_DONATION_TYPE_HUMAN_READABLE_MAP[donation_type_input]

    # Locate the district and branch
    selected_district = District.search_by_name(district_name).first || District.find_by(name: 'Default District')
    return 'END No matching district found.' unless selected_district

    branch = Branch.joins(:districts).find_by(districts: { id: selected_district.id }) || Branch.find_by(name: 'Haba na Haba Branch')
    return 'END No matching district found.' unless selected_district

    request = Request.create(
      phone_number:,
      name: request_name,
      request_type: 'food_donation',
      amount: donation_amount,
      food_type: ,
      food_name: ,
      district_id: selected_district.id,
      branch_id: branch.id
    )

    message = "Thank you for your donation we are reaching out to you shortly. Proceed to branch #{branch.name} in #{selected_district.name}"
    SmsHelper.send_sms(phone_number, message)

    return "END #{message}" if request.save(validate: true)

    'END Your request was not processed. Please try again'
  end
end
