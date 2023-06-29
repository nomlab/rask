Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :tags
  resources :api_tokens
  resources :projects
  resources :tasks
  resources :users
  resources :documents
  post '/documents/api_markdown', to: 'documents#api_markdown'

  get '/', to: redirect('/projects')

  get '/auth/:provider/callback', to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  get '/login', to: 'sessions#login_with_passwd_auth'

  # Defines the root path route ("/")
  # root "articles#index"
end
