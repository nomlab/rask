json.extract! document, :id, :content, :description, :created_at, :updated_at, :start_at, :end_at, :location
json.set! :creator do
  json.extract! document.user, :id, :name
end
json.set! :project do
  if document.project
    json.extract! document.project, :id, :name
  end
end
json.set! :tags do
  json.array! document.tags, :id, :name
end
json.url document_url(document, format: :json)
