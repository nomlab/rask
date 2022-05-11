json.extract! api_token, :id, :secret, :description, :expired_at, :created_at, :updated_at
json.set! :user do
  json.extract! api_token.user, :id, :name
end
json.url api_token_url(api_token, format: :json)
