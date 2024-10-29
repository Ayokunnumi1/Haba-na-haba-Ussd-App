Rails.application.routes.draw do
  devise_for :users, skip: [:registrations]

  root 'home#index'
  get 'home/index'
  resources :users
  resources :districts

  # Conditional root route
  authenticated :user do
    root to: 'users#index', as: :authenticated_root
  end

  unauthenticated do
    root to: 'home#index', as: :unauthenticated_root
  end
end
