module FoodDonationModule
    def self.process_request(text, phone_number, session)
      input_parts = text.split('*')
      request_name = input_parts[1]
      district_name = input_parts[2]
      county_name = input_parts[3]
      sub_county_name = input_parts[4]
      donor_type = input_parts[5]
      food_name = input_parts[6]
      amount = input_parts[7]
  
      # Locate the district and branch
      selected_district = District.search_by_name(district_name).first
      selected_county = County.search_by_name(county_name).first
      selected_sub_county = SubCounty.search_by_name(sub_county_name).first
  
      return 'END No matching district found.' if selected_district.nil?
      return 'END No matching county found.' if selected_county.nil?
      return 'END No matching sub county found.' if selected_sub_county.nil?
  
      puts "Selected district #{selected_district}"
      puts "Selected District: ID=#{selected_district.id}, Name=#{selected_district.name}"
  
      branch = Branch.joins(:districts).find_by(districts: { id: selected_district.id },)
      
      return 'END No matching district found.' if branch.nil?
  
      puts "Branch found: #{branch&.id}"
      puts "Request data: #{phone_number}, #{session[:name]}, #{selected_district&.id}, #{selected_county&.id}, #{selected_sub_county&.id}, #{branch&.id}"
      donation_type = if donor_type == '1'
        'Fresh Food'
      elsif donor_type == '2'
        'Dry Food'
      end
      # Create donation request
      request = Request.create(
        phone_number:,
        name: request_name,
        request_type: 'Donation',
        is_selected: true,
        district_id: selected_district.id,
        county_id: selected_county.id,
        sub_county_id: selected_sub_county.id,
        branch_id: branch.id,
      )
  
      # Create inventory record for the donation
      Inventory.create(
        donor_name: request_name,
        food_name:,
        donor_type: donation_type,
        amount:,
        district_id: selected_district.id,
        county_id: selected_county.id,
        sub_county_id: selected_sub_county.id,
        phone_number:,
        request_id: request.id,
      )
      'END Thank you for your donation we are reaching out to you shortly'
    end
  end
  