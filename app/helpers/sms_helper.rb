require 'AfricasTalking'

module SmsHelper
  def self.send_sms(phone_number, message)
    # Use the initialized AT SMS servic
    user_name = ENV.fetch('AFRICASTALKING_USERNAME', nil)
    api_key = ENV.fetch('AFRICASTALKING_API_KEY', nil)
    puts "#{api_key}, #{user_name} credentials"
    @at = AfricasTalking::Initialize.new(username, apiKey)
    sms = @at.sms
    options = {
      'to' => phone_number,
      'message' => message,
      'from' => 'HabaNaHaba'
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
