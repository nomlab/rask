module DocumentsHelper
  def preserve_other_params(except: [])
    forms = []
    params.except(:controller, :action, :commit, *except).each do |key, value|
      if key == 'q'
        value.each do |q_key, q_value|
          forms << hidden_field_tag("q[#{q_key}]", q_value)
        end
      else
        forms << hidden_field_tag(key, value)
      end
    end
    forms.join.html_safe
  end

  def sort_options
    [
      { value: 'content_asc', label: 'タイトル順（昇順）' },
      { value: 'content_desc', label: 'タイトル順（降順）' },
      { value: 'updated_at_asc', label: '更新順（古い順）' },
      { value: 'updated_at_desc', label: '更新順（新しい順）' },
      { value: 'created_at_asc', label: '作成順（古い順）' },
      { value: 'created_at_desc', label: '作成順（新しい順）' },
      { value: 'start_at_asc', label: '開始時刻順（昇順）' },
      { value: 'start_at_desc', label: '開始時刻順（降順）' }
    ]
  end

  def current_sort_value(q)
    current_sort = q.sorts.first&.name
    if current_sort.present?
      direction = q.sorts.first&.dir
      "#{current_sort}_#{direction}"
    else
      'content_asc'
    end
  end
end
