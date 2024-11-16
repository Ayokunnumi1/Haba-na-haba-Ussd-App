require "AfricasTalking"

module SmsHelper
    def self.send_sms(phone_number, message)
      # Use the initialized AT SMS servic
      username = ENV['AFRICASTALKING_USERNAME']
      apiKey = ENV['AFRICASTALKING_API_KEY']
      puts "#{apiKey}, #{username} credentials"
       @AT=AfricasTalking::Initialize.new(username, apiKey)
       sms = @AT.sms
      options = {
        "to" => phone_number,
        "message" => message,
        "from" => "HabaNaHaba"
      }
      puts "#{options}"
      begin
        reports = sms.send options
        puts "#{reports}"
      rescue AfricasTalking::AfricasTalkingException => ex
        Rails.logger.error "Failed to send SMS: #{ex.message}"
      end
    end
  end
  