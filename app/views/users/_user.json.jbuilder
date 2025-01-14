json.extract! user, :id, :name, :screen_name, :active, :created_at, :updated_at
json.url user_url(user, format: :json)
