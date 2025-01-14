json.extract! tag, :id, :name, :created_at, :updated_at
json.set! :tasks do
  json.array! tag.tasks, :id, :content
end
json.set! :documents do
  json.array! tag.documents, :id, :content
end
json.url tag_url(tag, format: :json)
