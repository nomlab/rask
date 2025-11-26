module TasksHelper
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
    p forms
    forms.join.html_safe
  end
end
