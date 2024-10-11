Rails.application.routes.draw do
  devise_for :users, skip: [:registrations]

  root to: 'users#index'

  resources :users, only: [:index, :new, :create, :edit, :update, :destroy]
end
