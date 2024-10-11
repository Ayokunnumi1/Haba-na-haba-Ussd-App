Rails.application.routes.draw do
  get 'home/index'
  devise_for :users, skip: [:registrations]

  # Conditional root route
  authenticated :user do
    root to: 'users#index', as: :authenticated_root
  end

  unauthenticated do
    root to: 'home#index', as: :unauthenticated_root
  end

  resources :users
end
