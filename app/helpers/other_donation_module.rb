module OtherDonationModule
  extend SmsHelper

  # Determine the request type based on user input
  DONATION_TYPE_MAP = {
    '1' => 'cash_donation',
    '2' => 'cloth_donation',
    '3' => 'other_donation'
  }.freeze

  # Map the donation type input to human-readable values
  DONATION_TYPE_HUMAN_READABLE_MAP = {
    '1' => 'Cash',
    '2' => 'Clothing',
    '3' => 'Other'
  }.freeze

  def self.process_menu_request(text, phone_number, _session)
    input_parts = text.split('*')
    request_name = input_parts[1]
    district_name = input_parts[2]
    donation_type_input = input_parts[3]
    donation_amount = input_parts[4]


    # Determine the request type based on user input
    request_type = DONATION_TYPE_MAP[donation_type_input]
    return 'END Invalid donation type selected.' if request_type.nil?

    # Map the donation type input to human-readable values
    donation_type_human_readable = DONATION_TYPE_HUMAN_READABLE_MAP[donation_type_input]

    # Locate the district and branch
    selected_district = District.search_by_name(district_name).first || District.find_by(name: 'Default District')
    return 'END No matching district found.' if selected_district.nil?
    
    branch = Branch.joins(:districts).find_by(districts: { id: selected_district.id }) || Branch.find_by(name: 'Haba na Haba Branch')
    return 'END No branch found for the selected district and county.' if branch.nil?

    Request.create(
      phone_number:,
      name: request_name,
      request_type: request_type,
      amount: donation_amount,
      district_id: selected_district.id,
      branch_id: branch.id
    )

    message = "Thank you for your #{donation_type_human_readable} donation. We are reaching out to you shortly. Proceed to branch #{branch.name} in #{selected_district.name}."
    SmsHelper.send_sms(phone_number, message)
    'END Thank you for your donation. We are processing your request and will call you shortly.'
  end
end
