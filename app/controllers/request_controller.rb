class RequestController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    params[:sessionId]
    phone_number = params[:phoneNumber]
    text = params[:text]
    params[:serviceCode]

    response = process_ussd(text, phone_number)

    render plain: response
  end

  def process_ussd(text, phone_number)
    case text
    when ''
      "CON Welcome to Haba na haba\n1. Request Food\n2. Donate Food\n3. Register a Food Bank"

    when '1'
      districts = District.pluck(:id, :name)
      district_options = districts.map { |id, name| "#{id}. #{name}" }.join("\n")
      "CON Select your District: \n#{district_options}"

    when /^1\*(\d+)$/
      district_id = text.split('*')[1]
      counties = County.where(district_id: district_id).pluck(:id, :name)
      county_options = counties.map { |id, name| "#{id}. #{name}" }.join("\n")
      "CON Select your County: \n#{county_options}"

    when /^1\*\d+\*(\d+)$/
      county_id = text.split('*')[2]
      sub_counties = SubCounty.where(county_id: county_id).pluck(:id, :name)
      sub_county_options = sub_counties.map { |id, name| "#{id}. #{name}" }.join("\n")
      "CON Select your Sub-County: \n#{sub_county_options}"

    when /^1\*\d+\*\d+\*(\d+)$/
      district_id = text.split('*')[1]
      county_id = text.split('*')[2]
      sub_county_id = text.split('*')[3]

      request_branch_id = Branch.where(district_id: district_id).pluck(:id)

      Request.create(
        phone_number: phone_number,
        name: "Test_requst", 
        request_type: "Food", 
        is_selected: "True",
        district_id: district_id, 
        county_id: county_id, 
        sub_county_id: sub_county_id,
        branch_id: request_branch_id,
        residence_address: "Wakiso",
      )
      "END We are processing your request and will call you shortly"

    when '2'
      districts = District.pluck(:id, :name)
      district_options = districts.map { |id, name| "#{id}. #{name}" }.join("\n")
      "CON Select your District: \n#{district_options}"

    when /^2\*(\d+)$/
      district_id = text.split('*')[1]
      counties = County.where(district_id: district_id).pluck(:id, :name)
      county_options = counties.map { |id, name| "#{id}. #{name}" }.join("\n")
      "CON Select your County: \n#{county_options}"

    when /^2\*\d+\*(\d+)$/
      county_id = text.split('*')[2]
      sub_counties = SubCounty.where(county_id: county_id).pluck(:id, :name)
      sub_county_options = sub_counties.map { |id, name| "#{id}. #{name}" }.join("\n")
      "CON Select your Sub-County: \n#{sub_county_options}"

    when /^2\*\d+\*\d+\*(\d+)$/
      district_id = text.split('*')[1]
      county_id = text.split('*')[2]
      sub_county_id = text.split('*')[3]

      'CON What Do you wish to donate'

    when /^2\*\d+\*\d+\*\w+\*(\w+)$/
      donation_type = text.split('*')[4]
      phone_number = phone_number

      "CON Enter expire date"

    when /^2\*\d+\*\d+\*\w+\*\w+\*(\w+)$/
      "CON Enter the collection date"

    when /^2\*\d+\*\d+\*\w+\*\w+\*\w+\*(\w+)$/
      "CON Enter the donation amount"

    when /^2\*\d+\*\d+\*\w+\*\w+\*\w+\*\w+\*(\w+)$/
      "END We will reach out to you shortly"

    when '3'
      "CON Enter branch name"

    when /^3\*(.+)$/
      @branch_name = text.split('*')[1]
    #   "CON Enter branch phone number"

    # when /^3\*\w+\*(\w+)$/
      @branch_phone = phone_number
      districts = District.pluck(:id, :name)
      district_options = districts.map { |id, name| "#{id}. #{name}" }.join("\n")
      "CON Select your District: \n#{district_options}"

    when /^3\*\w+\*\d+\*(\d+)$/
      district_id = text.split('*')[3]
      counties = County.where(district_id: district_id).pluck(:id, :name)
      county_options = counties.map { |id, name| "#{id}. #{name}" }.join("\n")
      "CON Select your County: \n#{county_options}"

    when /^3\*\w+\*\d+\*\d+\*(\d+)$/
      county_id = text.split('*')[4]
      
      Branch.create(
        name: @branch_name,
        phone_number: @branch_phone,
        district_id: district_id,
        county_id: county_id
      )
      "END Food Bank registered successfully! We will reach out to you shortly."

    else
      'END Invalid choice'
    end
  end
end
