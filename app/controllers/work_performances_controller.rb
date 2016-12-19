class WorkPerformancesController < ApplicationController
  load_and_authorize_resource
  load_resource :project
  load_resource :sprint

  def index
    @sprints = Sprint.list_by_user current_user
    @tasks = @sprint.tasks
  end

  def news
    render partial: "work_performances/form"
  end

  def create
    @work_performances = InputWorkPerformanceData.new(@sprint, params)
      .submit_work_performances
    respond_to do |format|
      format.json{render json: {wpd: @work_performances}}
    end
  end

  def update
    if params[:master_sprint_id] && params[:task_id] && params[:user_id]
      @work_performances = CheckWorkPerformanceExisted.new(@sprint, params)
        .check_wpd_if_existed
      respond_to do |format|
        if @work_performances.any?
          format.json{render json: {existed: :true, wpds: @work_performances}}
        else
          format.json{render json: {existed: :false, wpds: []}}
        end
      end
    end
  end

  private
  def work_performance_params
    params.require(:work_performance).permit WorkPerformance::ATTRIBUTES_PARAMS
  end
end
