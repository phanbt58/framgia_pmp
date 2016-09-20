module WorkPerformanceHelper
  def work_performances sprint, users
    performances_array = []
    sprint.item_performances.each do |item|
      item_data = user_performance(sprint, users, item)
      performances_array << item_data
    end
    return performances_array
  end

  private
  def user_performance sprint, users, item
    item_data = {name: item.name, data: []}
    sprint.master_sprints.order(:day).each do |day|
      item_value = WorkPerformance.performances_in_day(users, item, day)
        .sum(:performance_value)
      item_value /= (users.size.nonzero? || 1)
      item_data[:data] << item_value
    end
    return item_data
  end
end
