module TasksHelper
  def sort_options
    [
      { value: 'updated_at_desc', label: '更新順（新しい順）' },
      { value: 'updated_at_asc', label: '更新順（古い順）' },
      { value: 'created_at_desc', label: '作成順（新しい順）' },
      { value: 'created_at_asc', label: '作成順（古い順）' },
      { value: 'due_at_asc', label: '期限順（近い順）' },
      { value: 'due_at_desc', label: '期限順（遠い順）' },
      { value: 'project_id_asc', label: 'プロジェクト名順（昇順）' },
      { value: 'project_id_desc', label: 'プロジェクト名順（降順）' }
    ]
  end

  def current_sort_value(q)
    current_sort = q.sorts.find { |sort| sort.name != 'state_priority' }
    return 'due_at_asc' if current_sort.blank?

    "#{current_sort.name}_#{current_sort.dir}"
  end

  def days_to_deadline_as_string(task)
    days = task.days_to_deadline
    if days.finite?
      "期限まで後" + days.round.to_s + "日です！"
    else
      ""
    end
  end

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
end
