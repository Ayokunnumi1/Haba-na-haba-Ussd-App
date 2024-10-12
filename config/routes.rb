Rails.application.routes.draw do
  root 'test#index' 

  post 'request', to: 'request#index'  
  
  get "up" => "rails/health#show", as: :rails_health_check
end
