require 'rails_helper'

RSpec.describe EnglishMenu do
  let(:phone_number) { '1234567890' }
  let(:session) { {} }

  describe '.process_menu' do
    context 'when text is blank' do
      it 'returns the welcome menu' do
        expect(described_class.process_menu('', phone_number, session)).to eq(
          "CON Welcome to Haba na Haba\n1. Request Food\n2. Donate Food\n3. Other Donations"
        )
      end
    end

    context 'when an invalid action is provided' do
      it 'returns an invalid choice message' do
        expect(described_class.process_menu('4', phone_number, session)).to eq('END Invalid choice')
      end
    end

    context 'when action is valid' do
      it 'prompts for name when no inputs are provided' do
        expect(described_class.process_menu('1', phone_number, session)).to eq('CON Enter your name')
      end

      it 'prompts for district when one input is provided' do
        expect(described_class.process_menu('1*John', phone_number, session)).to eq('CON Enter your District')
      end

      it 'handles extra steps for food donation' do
        expect(described_class.process_menu('2*John*Nairobi', phone_number, session)).to eq(
          "CON Choose type of food:\n1. Fresh Food\n2. Dry Food"
        )
        expect(described_class.process_menu('2*John*Nairobi*1', phone_number, session)).to eq('CON Enter food name')
        expect(described_class.process_menu('2*John*Nairobi*1*Rice', phone_number, session)).to eq(
          'CON Enter the donation amount (kgs)'
        )
      end

      it 'handles extra steps for other donations' do
        expect(described_class.process_menu('3*John*Nairobi', phone_number, session)).to eq(
          "CON Choose your Donation.\n1. Cash\n2. Clothing\n3. Other"
        )
        expect(described_class.process_menu('3*John*Nairobi*1', phone_number, session)).to eq(
          'CON Enter the donation Amount'
        )
      end

      it 'calls the module’s method when extra steps are completed' do
        allow(FoodRequestModule).to receive(:process_request).and_return('Processed food request')
        expect(described_class.process_menu('1*John*Nairobi*Complete', phone_number, session)).to eq(
          'Processed food request'
        )
      end
    end
  end

  describe '.handle_extra_steps' do
    it 'prompts the next step if within extra steps' do
      action_config = EnglishMenu::MENU_ACTIONS['2']
      inputs = %w[John Nairobi]
      expect(described_class.handle_extra_steps(inputs, action_config, '2*John*Nairobi', phone_number, session)).to eq(
        "CON Choose type of food:\n1. Fresh Food\n2. Dry Food"
      )
    end

    it 'calls the module method if all extra steps are completed' do
      action_config = EnglishMenu::MENU_ACTIONS['2']
      inputs = %w[John Nairobi 1 Rice 5]
      allow(FoodDonationModule).to receive(:process_request).and_return('Donation processed')
      expect(described_class.handle_extra_steps(inputs, action_config, '2*John*Nairobi*1*Rice*5', phone_number, session)).to eq(
        'Donation processed'
      )
    end
  end

  describe '.welcome_menu' do
    it 'returns the welcome menu message' do
      expect(described_class.welcome_menu).to eq(
        "CON Welcome to Haba na Haba\n1. Request Food\n2. Donate Food\n3. Other Donations"
      )
    end
  end

  describe '.enter_name' do
    it 'returns the enter name prompt' do
      expect(described_class.enter_name).to eq('CON Enter your name')
    end
  end

  describe '.enter_district' do
    it 'returns the enter district prompt' do
      expect(described_class.enter_district).to eq('CON Enter your District')
    end
  end

  describe '.invalid_choice' do
    it 'returns the invalid choice message' do
      expect(described_class.invalid_choice).to eq('END Invalid choice')
    end
  end
end
