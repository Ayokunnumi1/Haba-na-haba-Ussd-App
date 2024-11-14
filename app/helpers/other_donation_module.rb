module OtherDonationModule
    def self.process_menu_request(text, phone_number, _session)
      input_parts = text.split('*')
      request_name = input_parts[1]
      district_name = input_parts[2]
      county_name = input_parts[3]
      sub_county_name = input_parts[4]
      donor_type = input_parts[5]
      amount = input_parts[6]
  
      # Locate the district and branch
      selected_district = District.search_by_name(district_name).first
      selected_county = County.search_by_name(county_name).first
      selected_sub_county = SubCounty.search_by_name(sub_county_name).first
      
      return 'END No matching district found.' if selected_district.nil?
      return 'END No matching county found.' if selected_county.nil?
      return 'END No matching Sub county found.' if selected_sub_county.nil?
  
      branch = Branch.joins(:districts).find_by(districts: { id: selected_district.id })
      return 'END No branch found for the selected district and county.' if branch.nil?
      donation_type = if donor_type == '1'
        'Cash'
      elsif donor_type == '2'
        'Clothing'
      elsif donor_type == '3'
        'Other'
      end
      # Create request for donation
      request = Request.create(
        phone_number:,
        name: request_name,
        request_type: 'Donation',
        is_selected: true,
        district_id: selected_district.id,
        county_id: selected_county.id,
        sub_county_id: selected_sub_county.id,
        branch_id: branch.id
      )
  
      # Record the donation in inventory
      Inventory.create(
        donor_name: request_name,
        donor_type: donation_type,
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
  