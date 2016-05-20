module SprintHelper
  def get_work_date work_date, sprint
    work_date % sprint.work_day
  end
end
