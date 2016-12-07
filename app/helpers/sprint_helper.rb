module SprintHelper
  def sum_lost_hour
    sum_lost_hour = []
    @sprint.master_sprints.order(day: :asc).each do |master_sprint|
      lost_hour = TimeLog.total_lost_hour master_sprint
      sum_lost_hour << lost_hour
    end
    sum_lost_hour
  end

  def total_lost_hour
    sum_lost_hour.reduce(0, :+)
  end

  def total_work_hour
    work_hours = @sprint.assignees.map do |assignee|
      assignee.work_hour.nil? ? 0 : assignee.work_hour
    end
    work_hours.reduce(0, :+)
  end

  def get_time_log_by_assignee_master_sprint assignee, master_sprint
    TimeLog.find_by(assignee: assignee, master_sprint: master_sprint)
  end

  def get_log_work_by_activity_master_sprint task, master_sprint
    LogWork.find_by(task: task, master_sprint: master_sprint)
  end

  def get_master_sprint_id
    MasterSprint.last.id
  end
end
