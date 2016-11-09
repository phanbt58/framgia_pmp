class Supports::ColumnSupport
  def initialize sprint
    @sprint = sprint
  end

  def tasks
    @sprint.tasks
  end

  def assignees
    @sprint.assignees
  end

  def total_lost_hour
    @sprint.time_logs.size
  end

  def total_time_log
    @sprint.log_works.size
  end

  def total_master_sprint
    @sprint.master_sprints.size
  end
end
