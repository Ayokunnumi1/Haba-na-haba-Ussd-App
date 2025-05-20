require 'AfricasTalking'

module SmsHelper
  def self.send_sms(phone_number, message)
    # Use the initialized AT SMS servic
    user_name = ENV['AFRICASTALKING_USERNAME'] || "sandbox"
    api_key = ENV['AFRICASTALKING_API_KEY']
    puts "#{api_key}, #{user_name} credentials"
    @at = AfricasTalking::Initialize.new(user_name, api_key)
    sms = @at.sms
    options = {
      'to' => phone_number,
      'message' => message,
      'from' => 'Hnhfoodbank'
    }
    puts options
    begin
      reports = sms.send options
      puts reports
    rescue AfricasTalking::AfricasTalkingException => e
      Rails.logger.error "Failed to send SMS: #{e.message}"
    end
  end
end
