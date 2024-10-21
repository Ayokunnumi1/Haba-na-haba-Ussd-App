class RequestController < ApplicationController
  include EnglishMenu
  skip_before_action :verify_authenticity_token, only: [:index]

  def index
    phone_number = params[:phoneNumber]
    text = params[:text]

    response = process_ussd(text, phone_number)
    render plain: response
  end

  def process_ussd(text, phone_number)
    EnglishMenu.process_menu(text, phone_number)
  end
end
