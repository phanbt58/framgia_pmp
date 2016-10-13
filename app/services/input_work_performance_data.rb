class InputWorkPerformanceData

  def initialize sprint, user, params
    @sprint = sprint
    @user = user
    @params = params
  end

  def submit_work_performances
    if @params[:work_performance][:master_sprint_id] && @params[:work_performance][:activity_id]
      master_sprint = MasterSprint.find_by id: @params[:work_performance][:master_sprint_id]
      activity = Activity.find_by id: @params[:work_performance][:activity_id]
      work_performances = @sprint.work_performances.of_activity_in_day(@user.id,
        master_sprint, activity)
      work_performances.any? ? update_work_performances : create_work_performances
    end
  end

  private
  def create_work_performances
    work_performances = @params[:work_performances].map do |wpd|
      WorkPerformance.new wpd.merge(@params[:work_performance])
        .permit WorkPerformance::ATTRIBUTES_PARAMS
    end
    work_performances.map!(&:save)
  end

  def update_work_performances
    @params[:work_performances].map do |wpd|
      unless wpd[:performance_value].blank?
        work_performance = @sprint.work_performances.of_user_in_day_by_item(@user,
          @params[:work_performance][:activity_id], @params[:work_performance][:master_sprint_id],
          wpd[:item_performance_id])
        if work_performance.blank?
          WorkPerformance.create wpd.merge(@params[:work_performance])
            .permit WorkPerformance::ATTRIBUTES_PARAMS
        else
          work_performance.first.update_attributes activity_id: @params[:work_performance][:activity_id],
            master_sprint_id: @params[:work_performance][:master_sprint_id],
            performance_value: wpd[:performance_value]
        end
      end
    end
  end
end
