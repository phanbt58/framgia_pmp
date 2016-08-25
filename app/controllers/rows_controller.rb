class RowsController < ApplicationController
  def create
    @sprint = Sprint.find_by id: params[:sprint_id]
    @activity = @sprint.activities.build
    @product_backlogs = @sprint.project.product_backlogs
    @project = Project.find_by id: @sprint.project_id

    if @activity.save
      @assignees = @sprint.assignees
      @row_number = @sprint.activities.size - 1
      @master_sprints = @sprint.master_sprints.order(day: :asc)
      @log_work_count = @sprint.log_works.size
    end

    respond_to do |format|
      format.js
    end
  end

  def destroy
    @activity = Activity.find params[:activity_id]
    if @activity.destroy
      respond_to do |format|
        format.html {redirect_to project_sprint_path(@project)}
        format.json {head :no_content}
      end
    else
      respond_to do |format|
        format.html {redirect_to project_sprint_path(@project)}
        format.json {head :no_content}
      end
    end
  end
end
