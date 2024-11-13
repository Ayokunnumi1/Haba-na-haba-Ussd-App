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

  # Conditional root route
  authenticated :user do
    root to: 'users#index', as: :authenticated_root
  end

  unauthenticated do
    root to: 'home#index', as: :unauthenticated_root
  end
end
