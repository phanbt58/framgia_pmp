class EstimateLogworkService
  include SprintHelper
  include ActionView::Helpers::NumberHelper

  def initialize activities, sprint
    @activities = activities
    @sprint = sprint
  end

  def get_sum_remaining
    @activities.inject(0) do |sum, activity|
      sum += time_remaining_activity(activity)
    end
  end

  def get_sum_worked
    get_estimate_activities - get_sum_remaining
  end

  def get_percent_worked
    unless get_estimate_activities == 0
      return number_to_percentage(get_sum_worked.to_f / get_estimate_activities * 100,
        precision: 0)
    end
    return 0
  end

  def get_percent_remaining
    unless get_estimate_activities == 0
      return number_to_percentage(get_sum_remaining.to_f / get_estimate_activities * 100,
        precision: 0)
    end
    return 0
  end

  def get_estimate_activities
    @activities.inject(0) do |sum, activity|
      log_works = activity.log_works.order(day: :asc)
      sum + (log_works.any? ? log_works.first.remaining_time : 0)
    end
  end

  def sum_remaining_for_day log_works
    unless log_works.nil?
      log_works.inject([]) do |results, log_work|
        sum = 0
          @activities.each do |activity|
            time_logs = activity.log_works.collect{|log| log if log.day == log_work.day}
              .compact
            tem = time_logs.first.present? ? time_logs.first.remaining_time : 0
            sum += tem
          end
        results << sum
      end
    end
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
    activity.log_works.last.remaining_time.present? ?  activity.log_works.last.remaining_time : 0
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
