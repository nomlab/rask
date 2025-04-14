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
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
