module OtherDonationModule
  extend SmsHelper
  def self.process_menu_request(text, phone_number, _session)
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
    return 'END No matching Sub county found.' if selected_sub_county.nil?

    branch = Branch.joins(:districts).find_by(districts: { id: selected_district.id })
    return 'END No branch found for the selected district and county.' if branch.nil?

    Request.create(
      phone_number:,
      name: request_name,
      request_type: 'Donation',
      district_id: selected_district.id,
      county_id: selected_county.id,
      sub_county_id: selected_sub_county.id,
      branch_id: branch.id
    )

    message = "Thank you for your donation we are reaching out to you shortly. Proceed to branch #{branch.name} in #{selected_district.name}"
    SmsHelper.send_sms(phone_number, message)
    'END Thank you for your donation. We are processing your request and will call you shortly.'
  end
end
