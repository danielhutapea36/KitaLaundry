Rails.application.routes.draw do
  post '/auth/login', to: 'authentication#login'
  
  resources :orders, only: [:create, :index, :show]
  post '/webhooks/xendit', to: 'webhooks#xendit'
  
  resources :services, only: [] do
    collection do
      get :branches
    end
  end
  get '/services/branch/:branch_id', to: 'services#by_branch'
  get '/service-items/branch/:branch_id', to: 'services#items_by_branch'

  get '/customer/notifications/unread-count', to: 'mock#unread_count'
  get '/customer/notifications', to: 'mock#notifications'
  get '/service-items', to: 'mock#service_items'

  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
