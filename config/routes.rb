Rails.application.routes.draw do
  devise_for :users, skip: [:registrations]

  root 'test#index'

  resources :users, only: [:new, :create, :edit, :update]
end
