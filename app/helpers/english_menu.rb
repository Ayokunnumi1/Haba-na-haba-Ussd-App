module EnglishMenu
    include FoodRequestModule
    include FoodDonationModule
    include OtherDonationModule
  
    # rubocop:disable Metrics/CyclomaticComplexity
    # rubocop:disable Lint/DuplicateBranch
    def self.process_menu(text, phone_number, session)
      request = Request.find_by(phone_number:)
  
      # If no request found, ask for the user's name and store it in the session
      if request.nil?
        if text == ''
          return 'CON Please enter your name:'
        elsif session[:name].nil? && !text.empty?
          # Save the name entered by the user in session
          session[:name] = text.split('*').first
          # After storing the name, handle the rest of the input as menu options
          remaining_menu_input = text.split('*')[1..] # Extract the menu part
  
          if remaining_menu_input.empty?
            return "CON Welcome, #{session[:name]}!\n1. Request Food\n2. Donate Food\n3. Other Donations"
             name = session[:name]
          end
  
  
          # Continue processing the rest of the menu input
          return process_menu(remaining_menu_input.join('*'), phone_number, session)
  
        end
      elsif text == ''
        # If request exists, welcome the user by their name
        
        return "CON Welcome back, #{request.name}!\n1. Request Food\n2. Donate Food\n3. Other Donations"
        name = request.name
      end
  
      # Continue with menu processing as before
      case text
      when '1'
        enter_name
      when /^1\*([\w\s]+)$/
        enter_district
      when  /^1\*[\w\s]+\*([\w\s]+)$/ # Accept letters, numbers, and spaces for district
        enter_county
      when /^1\*[\w\s]+\*[\w\s]+\*([\w\s]+)$/  # Accept letters, numbers, and spaces for county
        enter_sub_county
      when /^1\*[\w\s]+\*[\w\s]+\*[\w\s]+\*([\w\s]+)$/  # Accept letters, numbers, and spaces for sub-county
        FoodRequestModule.process_request(text, phone_number, session, name)
      when '2'
        enter_name
      when /^2\*([\w\s]+)$/
        enter_district
      when /^2\*[\w\s]+\*([\w\s]+)$/
        enter_county
      when /^2\*[\w\s]+\*[\w\s]+\*([\w\s]+)$/ 
        enter_sub_county
      when /^2\*[\w\s]+\*[\w\s]+\*[\w\s]+\*([\w\s]+)$/
        'CON Enter food name you’re donating'
      when /^2\*[\w\s]+\*[\w\s]+\*[\w\s]+\*[\w\s]+\*([\w\s]+)$/
        'CON Enter the donation amount (kgs)'
      when /^2\*[\w\s]+\*[\w\s]+\*[\w\s]+\*[\w\s]+\*[\w\s]+\*([\w\s]+)$/  
        FoodDonationModule.process_request(text, phone_number, session)
      when '3'
        enter_name
      when  /^3\*([\w\s]+)$/
        enter_district
      when /^3\*[\w\s]+\*([\w\s]+)$/
        enter_county
      when /^3\*[\w\s]+\*[\w\s]+\*([\w\s]+)$/
        enter_sub_county
      when /^3\*[\w\s]+\*[\w\s]+\*[\w\s]+\*([\w\s]+)$/
        'CON What are you donating?'
      when /^3\*[\w\s]+\*[\w\s]+\*[\w\s]+\*[\w\s]+\*([\w\s]+)$/
        'CON Enter donation amount'
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
      "CON Welcome to Haba na haba\n1. Request Food\n2. Donate Food\n3. Other Donations"
    end
  end
  