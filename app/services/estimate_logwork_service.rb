class EstimateLogworkService
  include ActionView::Helpers::NumberHelper

  def initialize activities
    @activities = activities
  end

  def get_sum_remaining
    @activities.inject(0) do |sum, activity|
      sum + time_remaining_activity(activity)
    end
  end

  def get_sum_worked
    get_estimate_activities - get_sum_remaining
  end

  def get_percent_worked
    number_to_percentage(get_sum_worked.to_f / get_estimate_activities * 100,
      precision: 0)
  end

  def get_percent_remaining
    number_to_percentage(get_sum_remaining.to_f / get_estimate_activities * 100,
      precision: 0)
  end

  def get_estimate_activities
    @activities.inject(0) do |sum, activity|
      sum + activity.estimate
    end
  end

  def sum_remaining_for_day log_works
    log_works.inject([]) do |results, log_work|
      sum = @activities.inject(0) do |sum, activity|
        time_logs = activity.log_works.collect{|log| log if log.day == log_work.day}
          .compact
        sum += time_logs.first.remaining_time
      end
      results << sum
    end
  end

  private
  def time_remaining_activity activity
    activity.log_works.last.remaining_time
  end
end
