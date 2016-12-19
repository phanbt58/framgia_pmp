class ProjectStatusesController < ApplicationController
  load_resource :project

  def show
    respond_to do |format|
      format.json do
        render json: {
          current_status: @project[:status], status: Project.statuses.keys
        }
      end
    end
  end

  def update
    if @project.update_attributes status: params[:status].to_i
      respond_to do |format|
        format.json do
          render json: {
            status: @project.status.humanize.titleize,
            permission: (can? :update, @project)
          }
        end
      end
    end
  end
end
