json.extract! project, :id, :name, :created_at, :updated_at
json.set! :user do
  json.extract! project.user, :id, :name
end
json.url project_url(project, format: :json)
