class RowsController < ApplicationController
  def create
    @sprint = Sprint.find_by id: params[:sprint_id]
    @activity = @sprint.activities.build
    @product_backlogs = @sprint.project.product_backlogs

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
end
