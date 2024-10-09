class UssdController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    params[:sessionId]
    params[:phoneNumber]
    text = params[:text]
    params[:serviceCode]

    response = process_ussd(text)

    render plain: response
  end

  private

  def process_ussd(text)
    case text
    when ''

      "CON Welcome to Haba na haba\n1. Donate Food\n2. Request Food"
    when '1'
      'END Thank you for donating food'
    when '2'
      'END We would send you food shorthly'
    else
      'END Invalid choice'
    end
  end
end
