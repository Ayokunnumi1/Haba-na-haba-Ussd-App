Rails.application.routes.draw do
  root 'test#index' 

  post 'ussd', to: 'ussd#index'  
  
  get "up" => "rails/health#show", as: :rails_health_check
end
