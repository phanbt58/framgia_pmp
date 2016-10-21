class SprintsController < ApplicationController
  load_resource
  load_resource :project
  before_action :load_sprint, :load_tasks

  def show
    @product_backlogs = @sprint.product_backlogs
    if @sprint.include_user? current_user, @project
      all_log_works = @tasks.first.log_works if @tasks.any?
      @log_works_count = all_log_works.size rescue 0
      @estimate = EstimateLogworkService.new @tasks, @sprint rescue nil
      @log_estimates = @estimate.sum_remaining_for_day all_log_works
    else
      flash[:alert] = t "flashs.not_authorize"
      redirect_to root_path
    end
  end

  def update
    respond_to do |format|
      if @sprint.update_attributes sprint_params
        @sprint.update_start_date
        format.js {head :ok}
      else
        format.js {head :internal_server_error}
      end
    end
  end

  private
  def sprint_params
    params.require(:sprint).permit Sprint::SPRINT_ATTRIBUTES_PARAMS
  end

  def load_sprint
    @sprints = Sprint.list_by_user current_user
  end

  def load_tasks
    @tasks = @sprint.tasks
  end
end
