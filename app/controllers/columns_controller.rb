class ColumnsController < ApplicationController
  def create
    @master_sprints = params[:master_sprint].map do |master_sprint|
      MasterSprint.new master_sprint.last.permit :sprint_id, :date
    end
    if @master_sprints.map(&:save)
      @sprint = Sprint.find_by id: params[:sprint_id]
      @support_column = Supports::ColumnSupport.new @sprint
    end
    respond_to do |format|
      format.js
    end
  end

  def show
    @master_sprint = MasterSprint.find_by id: params[:master_sprint_id]
    if @master_sprint
      respond_to do |format|
        format.html do
          render partial: "sprints/delete_column_dialog",
            locals: {
              master_sprint: @master_sprint, sprint: @master_sprint.sprint,
              project: @master_sprint.sprint.project
            }
        end
      end
    end
  end

  def destroy
    @master_sprint = MasterSprint.find_by id: params[:master_sprint_id]
    @master_sprint.destroy
    respond_to do |format|
      format.html{redirect_to project_sprint_path(@project)}
      format.json do
        render json: {master_sprints: @master_sprint.sprint.master_sprints}
      end
    end
  end

  private
  def master_sprint_params
    params.require(:master_sprint).permit :sprint_id, :date
  end
end
