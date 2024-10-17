class RequestController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:index]

  def index
    phone_number = params[:phoneNumber]
    text = params[:text]

    # Handle USSD session and user input
    response = process_ussd(text, phone_number)
    render plain: response
  end

  def process_ussd(text, phone_number)
    # If this is a new session, ask for the language selection first
    return select_language if text.empty?

    # Split the user input into parts to manage the session state
    input_parts = text.split('*')

    # If this is the first entry (language selection)
    if input_parts.size == 1
      language_choice = input_parts.first
      if language_choice == '1'
        return welcome_menu('en')
      elsif language_choice == '2'
        return welcome_menu('lg')
      else
        return 'END Invalid choice. Please select a valid language.'
      end
    end

    # Check for language selection in the session data
    language = input_parts.first == '1' ? 'en' : 'lg'

    # Further menu handling based on the language
    process_menu(text, phone_number, language)
  end

  private

  # Language selection at the start of the session
  def select_language
    "CON Choose your language:\n1. English\n2. Luganda"
  end

  # Welcome menu depending on the selected language
  def welcome_menu(language)
    case language
    when 'en'
      "CON Welcome to Haba na Haba\n1. Request Food\n2. Donate Food\n3. Register a Food Bank"
    when 'lg'
      "CON Kulika mu Haba na Haba\n1. Weereza ekyokulya\n2. Waayo ekyokulya\n3. Wandikisa Food Bank"
    end
  end

  # General menu flow handler depending on the language
  def process_menu(text, phone_number, language)
    input_parts = text.split('*')

    case input_parts[1] # Main menu option
    when '1'
      case input_parts.length
      when 2
        select_district(language)
      when 3
        select_county(text, language)
      when 4
        select_sub_county(text, language)
      when 5
        process_request(text, phone_number, language)
      else
        invalid_choice(language)
      end
    when '2'
      case input_parts.length
      when 2
        select_district(language)
      when 3
        select_county(
          text, language
        )
      when 4
        select_sub_county(text, language)
      when 5
        donate_food(text, language)
      else
        invalid_choice(language)
      end
    when '3'
      case input_parts.length
      when 2
        enter_branch_name(language)
      when 3
        select_food_district(language)
      when 4
        select_food_county(text, language)
      else
        invalid_choice(language)
      end
    else
      invalid_choice(language)
    end
  end

  # Invalid choice message based on the language
  def invalid_choice(language)
    case language
    when 'en'
      'END Invalid choice'
    when 'lg'
      'END Ekisemba Kyo kikyamu'
    end
  end

  # Select district menu for both languages
  def select_district(language)
    districts = District.pluck(:id, :name)
    district_options = districts.map { |id, name| "#{id}. #{name}" }.join("\n")

    case language
    when 'en'
      "CON Select your District:\n#{district_options}"
    when 'lg'
      "CON Londa Disitulikiti yo:\n#{district_options}"
    end
  end

  # Select county menu for both languages
  def select_county(text, language)
    district_id = text.split('*')[2]
    counties = County.where(district_id:).pluck(:id, :name)
    county_options = counties.map { |id, name| "#{id}. #{name}" }.join("\n")

    case language
    when 'en'
      "CON Select your County:\n#{county_options}"
    when 'lg'
      "CON Londa ekibuga kyo:\n#{county_options}"
    end
  end

  # Select sub-county menu for both languages
  def select_sub_county(text, language)
    county_id = text.split('*')[3]
    sub_counties = SubCounty.where(county_id:).pluck(:id, :name)
    sub_county_options = sub_counties.map { |id, name| "#{id}. #{name}" }.join("\n")

    case language
    when 'en'
      "CON Select your Sub-County:\n#{sub_county_options}"
    when 'lg'
      "CON Londa akabuga kyo:\n#{sub_county_options}"
    end
  end

  # Handle food request processing in both languages
  def process_request(text, phone_number, language)
    district_id = text.split('*')[2]
    county_id = text.split('*')[3]
    sub_county_id = text.split('*')[4]

    branch = Branch.find_by(district_id:, county_id:)

    Request.create(
      phone_number:,
      name: 'Test_request', # Replace with actual user input in real implementation
      request_type: 'Food',
      district_id:,
      county_id:,
      sub_county_id:,
      branch_id: branch.id,
      residence_address: 'Wakiso' # You can replace this with actual input
    )

    case language
    when 'en'
      'END We are processing your request and will call you shortly.'
    when 'lg'
      'END Tugenda kukuyita ku ssimu mu bwangu okufuna obuyambi bwo.'
    end
  end

  # Donate food flow in both languages
  def donate_food(_text, language)
    case language
    when 'en'
      'CON What do you wish to donate?'
    when 'lg'
      'CON Kiki ky’oyagala okuwaayo?'
    end
  end

  # Handle branch registration in both languages
  def enter_branch_name(language)
    case language
    when 'en'
      'CON Enter branch name'
    when 'lg'
      'CON Yongeza erinnya lya offiisi y’okukuŋŋaanamu ebyokulya'
    end
  end

  def select_food_district(language)
    districts = District.pluck(:id, :name)
    district_options = districts.map { |id, name| "#{id}. #{name}" }.join("\n")

    case language
    when 'en'
      "CON Select your District:\n#{district_options}"
    when 'lg'
      "CON Londa Disitulikiti yo:\n#{district_options}"
    end
  end

  def select_food_county(text, language)
    district_id = text.split('*')[2]
    counties = County.where(district_id:).pluck(:id, :name)
    county_options = counties.map { |id, name| "#{id}. #{name}" }.join("\n")

    case language
    when 'en'
      "CON Select your County:\n#{county_options}"
    when 'lg'
      "CON Londa ekibuga kyo:\n#{county_options}"
    end
  end
end
