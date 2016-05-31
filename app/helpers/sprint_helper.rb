module SprintHelper
  def get_work_date work_date, sprint
    work_date % sprint.work_day
  end

  def sum_lost_hour
    sum_lost_hour = []
    @sprint.master_sprints.order(day: :asc).each do |master_sprint|
      lost_hour = TimeLog.total_lost_hour master_sprint
      sum_lost_hour << lost_hour
    end
    sum_lost_hour
  end

  def total_lost_hour
    sum_lost_hour.inject {|total, lost_hour| total + lost_hour}
  end

  def total_work_hour
    @sprint.assignees.inject(0) do |total, assignee|
      total + (assignee.work_hour.nil? ? 0 : assignee.work_hour)
    end
  end
end
