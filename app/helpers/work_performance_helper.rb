module WorkPerformanceHelper
  def work_performances sprint, user_ids, chart_type, view_type
    case view_type
    when "view_all"
      view_all_performances sprint, user_ids, chart_type
    when "compare"
      compare_performances sprint, user_ids
    end
  end

  private
  def view_all_performances sprint, user_ids, chart_type
    performances_array = []
    if chart_type.blank?
      items = sprint.item_performances
    else
      items = sprint.item_performances.list_by_chart_type(chart_type)
    end
    items.each do |item|
      item_data = user_performance(sprint, user_ids, item)
      performances_array << item_data
    end
    performances_array
  end

  def user_performance sprint, user_ids, item
    item_phase = sprint.phase_items.find_by item_performance_id: item.id

    visible = item.execute? ? true : false

    item_data = {name: item_phase.alias, data: [], visible: visible}
    sprint.master_sprints.order(:day).each do |day|
      item_value = WorkPerformance.performances_in_day(user_ids, item.id, day)
        .sum(:performance_value)
      item_data[:data] << item_value
    end
    item_data
  end

  def compare_performances sprint, user_ids
    performances_array = []
    user_ids.each do |user_id|
      user = User.find_by id: user_id
      performances_array << json_data(sprint, user)
    end
    performances_array
  end

  def json_data sprint, user
    {
      name: user.name,
      data: execute_datas(sprint, user.id),
      visible: true
    }
  end

  def execute_datas sprint, user_id
    data = []
    sprint.master_sprints.order(:day).each do |day|
      data << WorkPerformance.performances_in_day(user_id, 6, day)
        .sum(:performance_value)
    end
    data
  end
end
