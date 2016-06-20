class SprintsController < ApplicationController
  load_resource
  load_resource :project
  before_action :load_sprint, :load_activities

  def show
    if @sprint.include_user? current_user, @project
      all_log_works = @activities.first.log_works if @activities.any?
      @log_works_count = all_log_works.size rescue 0
      @estimate = EstimateLogworkService.new @activities, @sprint rescue nil
      @log_estimates = @estimate.sum_remaining_for_day all_log_works
    else
      flash[:alert] = t "flashs.not_authorize"
      redirect_to root_path
    end
  end

  def update
    if @sprint.update_attributes sprint_params
      @sprint.update_start_date
      flash[:success] = flash_message "updated"
      redirect_to project_sprint_path(@project, @sprint)
    else
      flash[:failed] = flash_message "not_updated"
      render :edit
    end
  end

  private
  def sprint_params
    params.require(:sprint).permit Sprint::SPRINT_ATTRIBUTES_PARAMS
  end

  def load_sprint
    @sprints = Sprint.list_by_user current_user
  end

  def load_activities
    @activities = @sprint.activities# Activity.fitler_log_works @sprint
  end
end
