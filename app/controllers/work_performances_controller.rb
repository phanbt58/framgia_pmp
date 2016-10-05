class WorkPerformancesController < ApplicationController
  load_resource
  load_resource :project
  load_resource :sprint

  def index
    @sprints = Sprint.list_by_user current_user
    @activities = @sprint.activities
  end

  def new
    @work_performances = []
    @sprint.item_performances.each do |item|
      @work_performances << item.work_performances.build
    end
    render partial: "work_performances/form"
  end

  def create
    @work_performances = InputWorkPerformanceData.new(@sprint, @current_user, params)
      .submit_work_performances
    respond_to do |format|
      format.json {render json: @work_performances}
    end
  end

  def update
    if params[:master_sprint_id] && params[:activity_id]
      @work_performances = CheckWorkPerformanceExisted.new(@sprint, @current_user, params)
        .check_WPD_if_existed
      respond_to do |format|
        if @work_performances.any?
          format.json {render json: {existed: :true, wpds: @work_performances}}
        else
          format.json {render json: {existed: :false, wpds: []}}
        end
      end
    end
  end

  private
  def work_performance_params
    params.permit WorkPerformance::ATTRIBUTES_PARAMS
  end
end
