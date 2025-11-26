module ApplicationHelper
  def tag_label(tag)
    raw %(<span class="inline-block bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-0 rounded"> #{tag.name}</span>)
  end

  def url_with_query(url, key, value)
    uri = URI(url)
    query = Rack::Utils.parse_query(uri.query)
    query[key] = value
    uri.query = query.to_query
    uri.to_s
  end
end
