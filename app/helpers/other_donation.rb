module OtherDonationModule
    def self.process_menu_request(text, phone_number, _session)
      input_parts = text.split('*')
      district_name = input_parts[1]
      county_name = input_parts[2]
      sub_county_name = input_parts[3]
      donor_name = input_parts[4]
      donor_type = input_parts[5]
      amount = input_parts[6]
  
      # Locate the district and branch
      selected_district = District.search_by_name(district_name).first
      selected_county = County.search_by_name(county_name).first
      selected_sub_county = SubCounty.search_by_name(sub_county_name).first
      
      return 'END No matching district found.' if selected_district.nil?
  
      branch = Branch.joins(:districts).find_by(districts: { id: selected_district.id })
      return 'END No branch found for the selected district and county.' if branch.nil?
  
      # Create request for donation
      request = Request.create(
        phone_number:,
        name: donor_name,
        request_type: 'Donation',
        is_selected: true,
        district_id: selected_district.id,
        county_id: selected_county.id,
        sub_county_id: selected_sub_county.id,
        branch_id: branch.id
      )
  
      # Record the donation in inventory
      Inventory.create(
        donor_name:,
        donor_type:,
        food_name: 'n/a',
        amount:,
        district_id: selected_district.id,
        county_id: selected_county.id,
        sub_county_id: selected_sub_county.id,
        phone_number:,
        request_id: request.id,
      )
  
      'END Thank you for your donation. We are processing your request and will call you shortly.'
    end
  end
  