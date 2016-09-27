module WorkPerformanceHelper
  def work_performances sprint, user_ids, chart_type
    performances_array = []
    sprint.item_performances.each do |item|
      if item.chart_type == chart_type
        item_data = user_performance(sprint, user_ids, item)
        performances_array << item_data
      end
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
end
