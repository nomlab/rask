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
end
