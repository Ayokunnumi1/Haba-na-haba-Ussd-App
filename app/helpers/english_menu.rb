module EnglishMenu
  include FoodRequestModule
  include FoodDonationModule
  include OtherDonationModule

  # rubocop:disable Metrics/CyclomaticComplexity
  # rubocop:disable Lint/DuplicateBranch
  def self.process_menu(text, phone_number, session)
    request = Request.find_by(phone_number:)

    # Directly welcome the user and show the main menu
    if text == ''
      return "CON Welcome to Haba na Haba\n1. Request Food\n2. Donate Food\n3. Other Donations" if request

      # If request exists, welcome the user by their name


      return welcome_menu

    end

    # Continue with menu processing as before
    case text
    when '1'
      enter_name
    when /^1\*([\w\s]+)$/
      enter_district
    when /^1\*[\w\s]+\*([\w\s]+)$/
      enter_county
    when /^1\*[\w\s]+\*[\w\s]+\*([\w\s]+)$/
      enter_sub_county
    when /^1\*[\w\s]+\*[\w\s]+\*[\w\s]+\*([\w\s]+)$/
      FoodRequestModule.process_request(text, phone_number, session)
    when '2'
      enter_name
    when /^2\*([\w\s]+)$/
      enter_district
    when /^2\*[\w\s]+\*([\w\s]+)$/
      enter_county
    when /^2\*[\w\s]+\*[\w\s]+\*([\w\s]+)$/
      enter_sub_county
    when /^2\*[\w\s]+\*[\w\s]+\*[\w\s]+\*([\w\s]+)$/
      "CON What are you donating:\n1. Fresh Food\n2. Dry Food"
    when /^2\*[\w\s]+\*[\w\s]+\*[\w\s]+\*[\w\s]+\*([\w\s]+)$/
      'CON Enter food name'
    when /^2\*[\w\s]+\*[\w\s]+\*[\w\s]+\*[\w\s]+\*[\w\s]+\*([\w\s]+)$/
      'CON Enter the donation amount (kgs)'
    when /^2\*[\w\s]+\*[\w\s]+\*[\w\s]+\*[\w\s]+\*[\w\s]+\*[\w\s]+\*([\w\s]+)$/
      FoodDonationModule.process_request(text, phone_number, session)
    when '3'
      enter_name
    when /^3\*([\w\s]+)$/
      enter_district
    when /^3\*[\w\s]+\*([\w\s]+)$/
      enter_county
    when /^3\*[\w\s]+\*[\w\s]+\*([\w\s]+)$/
      enter_sub_county
    when /^3\*[\w\s]+\*[\w\s]+\*[\w\s]+\*([\w\s]+)$/
      "CON Choose your Donation.\n1. Cash\n2. Clothing\n3. Other"
    when /^3\*[\w\s]+\*[\w\s]+\*[\w\s]+\*[\w\s]+\*([\w\s]+)$/
      'CON Enter the donation Amount'
    when /^3\*[\w\s]+\*[\w\s]+\*[\w\s]+\*[\w\s]+\*[\w\s]+\*([\w\s]+)$/
      OtherDonationModule.process_menu_request(text, phone_number, session)
    else
      'END Invalid choice'
    end
  end
  # rubocop:enable Metrics/CyclomaticComplexity
  # rubocop:enable Lint/DuplicateBranch

  def self.enter_name
    'CON Enter your name'
  end

  def self.enter_district
    'CON Enter your District'
  end

  def self.enter_sub_county
    'CON Enter your Sub-County'
  end

  def self.enter_county
    'CON Enter your County'
  end

  def self.welcome_menu
    "CON Welcome to Haba na Haba\n1. Request Food\n2. Donate Food\n3. Other Donations"
  end
end
