module ApplicationHelper
  def tag_label(tag)
    raw %(<span class="inline-block bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-0 rounded"> #{tag.name}</span>)
  end
end
