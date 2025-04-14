Rails.application.routes.draw do

  mount Rswag::Ui::Engine => '/api-docs'

  resources :tags
  resources :api_tokens
  resources :projects
  resources :tasks
  resources :users
  resources :documents

  post '/documents/api_markdown', to: 'documents#api_markdown'
  root 'tasks#index'
  get '/welcome', to: 'welcome#index', as: :welcome
  get '/auth/:provider/callback', to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  get '/login', to: 'sessions#login_with_passwd_auth'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
