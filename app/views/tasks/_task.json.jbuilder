json.extract! task, :id, :content, :description, :due_at, :created_at, :updated_at
json.set! :creator do
  json.extract! task.user, :id, :name
end
json.set! :assigner do
  json.extract! task.assigner, :id, :name
end
json.set! :project do
  if task.project
    json.extract! task.project, :id, :name
  end
end
json.set! :tags do
  json.array! task.tags, :id, :name
end
json.url task_url(task, format: :json)
