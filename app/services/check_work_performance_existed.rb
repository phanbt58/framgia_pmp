class CheckWorkPerformanceExisted

  def initialize sprint, params
    @sprint = sprint
    @params = params
  end

  def check_WPD_if_existed
    check_WPD_existed
  end

  private
  def check_WPD_existed
    if @params[:master_sprint_id] && @params[:activity_id]
      master_sprint_id = @params[:master_sprint_id]
      activity_id = @params[:activity_id]
      user_id = @params[:user_id]
      work_performances = @sprint.work_performances.of_activity_in_day(user_id,
        master_sprint_id, activity_id)
    end
    work_performances
  end
end
