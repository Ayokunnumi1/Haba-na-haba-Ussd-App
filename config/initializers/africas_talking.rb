require "AfricasTalking"

username = ENV['AFRICASTALKING_USERNAME']
apiKey 	= ENV['AFRICASTALKING_API_KEY']
@AT=AfricasTalking::Initialize.new(username, apiKey)
