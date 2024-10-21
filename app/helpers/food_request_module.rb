module FoodRequestModule
  def self.handle(text, phone_number)
    input_parts = text.split('*')

    case input_parts.length
    when 1
      select_district
    when /^1\*(\d+)$/
      select_county(text)
    when /^1\*\d+\*(\d+)$/
      select_sub_county(text)
    when /^1\*\d+\*\d+\*(\d+)$/
      process_request(text, phone_number)
    else
      'END Invalid choice'
    end
  end

  def self.select_district
    districts = District.pluck(:id, :name)
    district_options = districts.map { |id, name| "#{id}. #{name}" }.join("\n")

    "CON Select your District:\n#{district_options}"
  end

  def self.select_county(text, _phone_number)
    district_id = text.split('*')[1]
    counties = County.where(district_id:).pluck(:id, :name)
    county_options = counties.map { |id, name| "#{id}. #{name}" }.join("\n")

    "CON Select your County:\n#{county_options}"
  end

  def self.select_sub_county(text, _phone_number)
    county_id = text.split('*')[2]
    sub_counties = SubCounty.where(county_id:).pluck(:id, :name)
    sub_county_options = sub_counties.map { |id, name| "#{id}. #{name}" }.join("\n")

    "CON Select your Sub-County:\n#{sub_county_options}"
  end

  def self.process_request(text, phone_number)
    district_id = text.split('*')[1]
    county_id = text.split('*')[2]
    sub_county_id = text.split('*')[3]

    branch = Branch.find_by(district_id:, county_id:)

    Request.create(
      phone_number:,
      name: 'Test_request',
      request_type: 'Food',
      is_selected: true,
      district_id:,
      county_id:,
      sub_county_id:,
      branch_id: branch.id,
      residence_address: 'Wakiso'
    )

    'END We are processing your request and will call you shortly.'
  end
end
