Rails.application.routes.draw do
  devise_for :users, skip: [:registrations]

  # Conditional root route
  authenticated :user do
    root to: 'users#index', as: :authenticated_root
  end

  unauthenticated do
    root to: 'home#index', as: :unauthenticated_root
  end

  root "home#index"
  post "create_request", to: "home#create_request"
  get 'home/index'
  get 'home/load_counties', to: 'home#load_counties'
  get 'home/load_sub_counties', to: 'home#load_sub_counties'
  get 'dashboard', to: 'dashboard#index', as: 'dashboard'
  post  'ussd_request', to: 'requests#ussd'
  get 'top_donors', to: 'inventories#top_donors'
  resources :users
  resources :districts do
    resources :counties do
      resources :sub_counties, only: [:new, :create]
    end
  end
  resources :counties
  resources :sub_counties
  resources :events do
    resources :requests
  end

  resources :notifications, only: [:index]

  resources :event_users, only: [:create, :destroy]
  resources :branches do
    collection do
      get :load_counties
    end
  end
  resources :requests do
    collection do
      get :load_counties
      get :load_sub_counties
      get :load_branches
    end
    resource :individual_beneficiary, only: [:new, :create, :edit, :update] do
      collection do
        get :load_counties, to: 'individual_beneficiaries#load_counties'
        get :load_sub_counties, to: 'individual_beneficiaries#load_sub_counties'
      end
    end
    resource :family_beneficiary, only: [:new, :create, :edit, :update] do
      collection do
        get :load_counties, to: 'family_beneficiaries#load_counties'
        get :load_sub_counties, to: 'family_beneficiaries#load_sub_counties'
      end
    end
    resource :organization_beneficiary, only: [:new, :create, :edit, :update] do
      collection do
        get :load_counties, to: 'organization_beneficiaries#load_counties'
        get :load_sub_counties, to: 'organization_beneficiaries#load_sub_counties'
      end
    end
    resources :inventories, only: [:new, :create, :edit, :update] do
      collection do
        get :load_counties, to: 'inventories#load_counties'
        get :load_sub_counties, to: 'inventories#load_sub_counties'
      end
    end
  end
  resources :individual_beneficiaries, only: [:index, :show, :destroy] do
    collection do
      get :load_counties
      get :load_sub_counties
    end
  end
  resources :family_beneficiaries, only: [:index, :show, :destroy] do
    collection do
      get :load_counties
      get :load_sub_counties
    end
  end
  resources :organization_beneficiaries, only: [:index, :show, :destroy] do
    collection do
      get :load_counties
      get :load_sub_counties
    end
  end
  resources :inventories, only: [:index, :show, :destroy]

  resources :requests do
    resources :inventories, only: [:index, :show, :destroy, :edit, :update] do
      collection do
        get 'load_counties'
        get 'load_sub_counties'
      end
    end
  end
end
