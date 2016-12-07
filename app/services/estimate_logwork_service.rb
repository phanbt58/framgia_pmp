class EstimateLogworkService
  include SprintHelper
  include ActionView::Helpers::NumberHelper
  attr_reader :sum_estimate

  def initialize tasks, sprint
    @tasks = tasks
    @sprint = sprint
    @sum_estimate = sum_logwork_day 0
  end

  def get_sum_remaining
    @tasks.map{|task| time_remaining_activity(task)}.reduce(0, :+)
  end

  def get_sum_worked
    @sum_estimate - get_sum_remaining
  end

  def get_percent_worked
    unless @sum_estimate.zero?
      return number_to_percentage(get_sum_worked.to_f / @sum_estimate * 100,
        precision: 0)
    end
    0
  end

  def get_percent_remaining
    unless @sum_estimate.zero?
      return number_to_percentage(get_sum_remaining.to_f / @sum_estimate * 100,
        precision: 0)
    end
    0
  end

  def get_time_remaining
    get_time_remaining_team
  end

  def sum_logwork_day day
    sum = 0
    @tasks.each do |task|
      logwork_day = task.log_works.map(&:remaining_time)
      sum += logwork_day[day] || 0
    end
    sum
  end

  def sum_remaining_for_day log_works
    (0..log_works.size - 1).map{|day| sum_logwork_day day} unless log_works.nil?
  end

  def get_time_remaining_team
    arr = []
    remaining = @sum_estimate
    get_arr_lost_hour.each do |rm|
      wh = remaining - rm
      arr << wh
      remaining = wh
    end
    arr
  end

  private
  def time_remaining_activity task
    task.log_works.any? ? task.log_works.pluck(:remaining_time).min : 0
  end

  def get_arr_lost_hour
    arr = []
    wh = total_work_hour
    sum_lost_hour.each_with_index do |_lost_hour, index|
      arr << wh - sum_lost_hour[index]
    end
    arr
  end
end
