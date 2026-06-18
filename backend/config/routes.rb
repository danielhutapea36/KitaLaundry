Rails.application.routes.draw do
  post '/auth/login', to: 'authentication#login'
  post '/auth/register', to: 'users#create'
  get '/auth/profile', to: 'authentication#profile'
  post '/auth/verify-email', to: 'authentication#verify_email'
  post '/auth/resend-verification', to: 'authentication#resend_verification'

  namespace :admin do
    get 'dashboard/stats', to: 'dashboard#stats'
    resources :users
    resources :orders, only: [:index] do
      member do
        post :assign_to_branch
        post :assign_to_logistics
        post :process_refund
      end
      collection do
        post :scan_barcode
      end
    end
  end

  resources :orders, only: [:create, :index, :show] do
    member do
      get :tracking
      post :cancel
      post :rate
      post :reorder
    end
  end
  
  resources :addresses, only: [:index, :create, :update, :destroy] do
    member do
      put :set_default
    end
  end

  post '/webhooks/xendit', to: 'webhooks#xendit'
  
  resources :services, only: [] do
    collection do
      get :branches
      post :calculate
      get :time_slots
      get :availability
    end
  end
  get '/services/branch/:branch_id', to: 'services#by_branch'
  get '/service-items/branch/:branch_id', to: 'services#items_by_branch'

  resources :notifications, only: [:index] do
    collection do
      get :unread_count
      put :mark_read
    end
  end
  get '/service-items', to: 'mock#service_items'

  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
