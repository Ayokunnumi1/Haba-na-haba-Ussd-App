require 'AfricasTalking'

module SmsHelper
  def self.send_sms(phone_number, message)
    # Use the initialized AT SMS servic
    user_name = "sandbox"
    api_key = "atsk_7024daf0e35e181bf604049c4671ac1db5b4ca52af5287a1de914cb48f994ebfc78fd165"
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
