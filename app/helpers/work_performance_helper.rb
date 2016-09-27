module WorkPerformanceHelper
  def work_performances sprint, user_ids
    performances_array = []
    sprint.item_performances.each do |item|
      item_data = user_performance(sprint, user_ids, item)
      performances_array << item_data
    end
    return performances_array
  end

  def work_performance_for_burn_up sprint, user_ids
    performances_array = []
    sprint.item_performances.each do |item|
      item_data = user_performance_burnup(sprint, user_ids, item)
      performances_array << item_data
    end
    return performances_array
  end

  private
  def user_performance sprint, user_ids, item
    visible = sprint.phase_items.find_by(item_performance_id: item.id).visible

    item_data = {name: item.name, data: [], visible: visible}
    sprint.master_sprints.order(:day).each do |day|
      item_value = WorkPerformance.performances_in_day(user_ids, item, day)
        .sum(:performance_value)
      item_value /= (user_ids.size.nonzero? || 1)
      item_data[:data] << item_value
    end
    return item_data
  end

  def user_performance_burnup sprint, user_ids, item_data
    item_data = user_performance( sprint, user_ids, item_data)
    for i in (1..(item_data[:data].length - 1)) do
      item_data[:data][i] += item_data[:data][i - 1]
    end
    return item_data
  end
end
