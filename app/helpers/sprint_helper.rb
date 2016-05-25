module SprintHelper
  def get_work_date work_date, sprint
    work_date % sprint.work_day
  end

  def sum_lost_hour
    sum_lost_hour = []
    @sprint.master_sprints.each_with_index do |_, day|
      lost_hour = TimeLog.total_lost_hour @sprint, day
      sum_lost_hour << lost_hour
    end
    sum_lost_hour
  end

  def total_lost_hour
    sum_lost_hour.drop(1).inject {|total, lost_hour| total + lost_hour}
  end
end
