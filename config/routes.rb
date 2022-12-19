Rails.application.routes.draw do

  resources :tags
  resources :api_tokens
  resources :projects
  resources :tasks do
    collection do
      get 'search'
    end
  end
  resources :users
  resources :documents do
    collection do
      get 'search'
    end
  end
  post '/documents/api_markdown', to: 'documents#api_markdown'

  get '/', to: redirect('/projects')

  get '/auth/:provider/callback', to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
