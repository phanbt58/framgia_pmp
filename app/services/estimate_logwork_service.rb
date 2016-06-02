class EstimateLogworkService
  include SprintHelper
  include ActionView::Helpers::NumberHelper

  def initialize activities, sprint
    @activities = activities
    @sprint = sprint
    @sum_estimate = sum_logwork_day 0
    @arr_remaining_time = get_time_remaining_team
  end

  def get_sum_remaining
    @activities.inject(0) do |sum, activity|
      sum += time_remaining_activity(activity)
    end
  end

  def get_sum_worked
    @sum_estimate - get_sum_remaining
  end

  def get_percent_worked
    unless @sum_estimate == 0
      return number_to_percentage(get_sum_worked.to_f / @sum_estimate * 100,
        precision: 0)
    end
    return 0
  end

  def get_percent_remaining
    unless @sum_estimate == 0
      return number_to_percentage(get_sum_remaining.to_f / @sum_estimate * 100,
        precision: 0)
    end
    return 0
  end

  def get_estimate_activities
    @sum_estimate
  end

  def get_time_remaining
    @arr_remaining_time
  end

  def sum_logwork_day day
    sum = 0
    @activities.each do |activity|
      logwork_day = activity.log_works.map{|log| log.remaining_time}
      sum += logwork_day[day] || 0
    end
    return sum
  end

  def sum_remaining_for_day log_works
    (0..log_works.size - 1).map {|day| sum_logwork_day day} unless log_works.nil?
  end

  def get_time_remaining_team
    arr = []
    remaining = get_estimate_activities
    get_arr_lost_hour.each do |rm|
      wh = remaining - rm
      arr << wh
      remaining = wh
    end
    arr
  end

  private
  def time_remaining_activity activity
    activity.log_works.last.remaining_time.present? ?
      activity.log_works.last.remaining_time : 0
  end

  def get_arr_lost_hour
    arr = []
    wh = total_work_hour
    sum_lost_hour.each_with_index do |lost_hour, index|
      arr << wh - sum_lost_hour[index]
    end
    arr
  end
end
