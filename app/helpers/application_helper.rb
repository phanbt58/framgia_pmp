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
    when :failed then "alert-danger"
    end
  end

  def activity_class task
    assignee = task.user
    log_works = task.log_works
    estimate = log_works.any? ? log_works.first.remaining_time : 0
    remaining = task.log_works.empty? ? 0 : task.log_works.last.remaining_time

    if assignee.nil?
      estimate != 0 ? (remaining != 0 ? "estimated" : "default") : "default"
    else
      estimate != 0 ? (remaining != 0 ? "processed" : "default") : "assigned"
    end
  end

  def product_backlog_class product_backlog
    actual_time = product_backlog.actual
    remaining_time = product_backlog.total_remaining_time
    if (remaining_time == 0 && actual_time == 0) || remaining_time.nil?
      "default"
    else
      (remaining_time == 0 && actual_time !=0) ? "finished" : "in_progress"
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

  def verity_admin?
    if current_user.member?
      redirect_to root_url
      flash[:success] = t "sessions.not_admin"
    end
  end

  def home_page
    (current_user.nil? || !current_user.is_root?) ? root_path : admin_projects_path
  end
end
