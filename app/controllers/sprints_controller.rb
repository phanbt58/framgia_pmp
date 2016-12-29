class SprintsController < ApplicationController
  load_resource
  load_resource :project
  before_action :load_assignees, except: [:index, :destroy]
  before_action :load_sprint, :load_tasks, :load_assignees_not_in_sprint

  def new
  end

  def create
    @sprint.create_name
    if @sprint.save
      flash[:success] = flash_message :created
      redirect_to project_sprint_path(@project, @sprint)
    else
      flash.now[:failed] = flash_message :not_created
      render :new
    end
  end

  def show
    @product_backlogs = @sprint.product_backlogs
    all_log_works = @tasks.first.log_works if @tasks.any?
    @log_works_count = all_log_works.size
    @estimate = EstimateLogworkService.new @tasks, @sprint
    @log_estimates = @estimate.sum_remaining_for_day all_log_works
  end

  def edit
  end

  def update
    respond_to do |format|
      if @sprint.update_attributes sprint_params
        @sprint.update_start_date
        format.html{redirect_to project_sprint_path(@project, @sprint)}
        format.js{head :ok}
      else
        format.js{head :internal_server_error}
      end
    end
  end

  def destroy
    if @sprint.destroy
      flash[:success] = flash_message :deleted
      redirect_to project_path(@project)
    else
      flash.now[:failed] = flash_message :not_updated
      redirect_to project_sprint_path(@project, @sprint)
    end
  end

  private
  def sprint_params
    params.require(:sprint).permit Sprint::SPRINT_ATTRIBUTES_PARAMS
  end

  def load_sprint
    @sprints = @project.sprints
  end

  def load_tasks
    @tasks = @sprint.tasks
  end

  def load_assignees
    @assignees = @project.members
  end

  def load_assignees_not_in_sprint
    @assignees_not_in_sprint = @assignees.not_in_sprint(@sprint.assignees
      .map(&:member_id))
  end
end
