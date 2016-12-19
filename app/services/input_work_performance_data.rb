class InputWorkPerformanceData
  def initialize sprint, params
    @sprint = sprint
    @params = params
    @master_sprint_id = params[:work_performance][:master_sprint_id]
    @phase_id = params[:work_performance][:phase_id]
    @task_id = params[:work_performance][:task_id]
  end

  def submit_work_performances
    work_performances = @sprint.work_performances
      .of_activity_in_day(@master_sprint_id, @task_id, @phase_id)
    work_performances.any? ? update_work_performances : create_work_performances
    work_performances
  end

  private
  def create_work_performances
    if @task_id
      work_performance = WorkPerformance.new work_performance_params
      work_performance.save
    end
  end

  def update_work_performances
    if @task_id
      unless @params[:work_performance][:performance_value].blank?
        work_performance = @sprint.work_performances
          .of_activity_in_day(@master_sprint_id, @task_id, @phase_id)
        if work_performance.blank?
          WorkPerformance.create work_performance_params
        else
          work_performance.first.update_attributes work_performance_params
        end
      end
    end
  end

  def work_performance_params
    @params.require(:work_performance).permit WorkPerformance::ATTRIBUTES_PARAMS
  end
end
