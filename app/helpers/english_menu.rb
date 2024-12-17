module EnglishMenu
  include FoodRequestModule
  include FoodDonationModule
  include OtherDonationModule

  MENU_ACTIONS = {
    '1' => {
      module: FoodRequestModule,
      process_method: :process_request
    },
    '2' => {
      module: FoodDonationModule,
      process_method: :process_request,
      extra_steps: [
        "Choose type of food:\n1. Fresh Food\n2. Dry Food",
        'Enter food name',
        'Enter the donation amount (kgs)'
      ]
    },
    '3' => {
      module: OtherDonationModule,
      process_method: :process_menu_request,
      extra_steps: [
        "Choose your Donation.\n1. Cash\n2. Clothing\n3. Other",
        'Enter the donation Amount'
      ]
    }
  }.freeze

  def self.process_menu(text, phone_number, session)
    return welcome_menu if text.blank?

    action, *inputs = text.split('*')
    action_config = MENU_ACTIONS[action]

    return invalid_choice unless action_config

    case inputs.length
    when 0
      enter_name
    when 1
      enter_district
    else
      handle_extra_steps(inputs, action_config, text, phone_number, session)
    end
  end

  def self.handle_extra_steps(inputs, action_config, text, phone_number, session)
    extra_steps = action_config[:extra_steps]
    step_index = inputs.length - 4

    if extra_steps && step_index < extra_steps.length
      "CON #{extra_steps[step_index]}"
    else
      action_config[:module].send(action_config[:process_method], text, phone_number, session)
    end
  end

  def self.welcome_menu
    "CON Welcome to Haba na Haba\n1. Request Food\n2. Donate Food\n3. Other Donations"
  end

  def self.enter_name
    'CON Enter your name'
  end

  def self.enter_district
    'CON Enter your District'
  end

  def self.invalid_choice
    'END Invalid choice'
  end
end
