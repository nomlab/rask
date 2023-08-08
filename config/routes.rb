Rails.application.routes.draw do

  resources :tags
  resources :api_tokens
  resources :projects
  resources :tasks
  resources :users
  resources :documents
  post '/documents/api_markdown', to: 'documents#api_markdown'
  
  get '/', to: redirect('/tasks')

  get '/auth/:provider/callback', to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  get '/login', to: 'sessions#login_with_passwd_auth'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
