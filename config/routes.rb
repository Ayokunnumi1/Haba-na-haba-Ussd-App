Rails.application.routes.draw do
  get 'counties/index'
  get 'counties/show'
  get 'counties/new'
  get 'counties/edit'
  devise_for :users, skip: [:registrations]

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
