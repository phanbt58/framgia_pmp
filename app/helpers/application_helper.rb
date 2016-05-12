module ApplicationHelper
  def full_title page_title = ""
    base_title = t "project_name"
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end
  
  def flash_class level
    case level
    when :notice then "alert-info"
    when :error then "alert-error"
    when :alert then "alert-warning"
    when :success then "alert-success"
    end
  end

  def flash_message flash_type, *params
    if params.empty?
      t "flashs.messages.#{flash_type}", model_name: controller_name.classify
    else
      t "flashs.messages.#{flash_type}", 
        models_name: params[0].join(", ") unless params[0].empty?
    end
  end

  def tab_active tab_name, current_tab
    current_tab == tab_name ? "active" : nil
  end
end
