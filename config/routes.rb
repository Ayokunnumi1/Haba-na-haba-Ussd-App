Rails.application.routes.draw do
  devise_for :users, skip: [:registrations]

  get 'home/index'
  resources :users
  resources :districts
  resources :counties
  resources :sub_counties
  resources :branches do
    collection do
      get :load_counties
    end
  end
  resources :requests do
    collection do
      get :load_counties
      get :load_sub_counties
    end
  end

  # Conditional root route
  authenticated :user do
    root to: 'users#index', as: :authenticated_root
  end

  unauthenticated do
    root to: 'home#index', as: :unauthenticated_root
  end
end
