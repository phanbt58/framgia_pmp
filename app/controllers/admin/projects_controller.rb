class Admin::ProjectsController < ApplicationController
  load_and_authorize_resource

  def create
    if @project.save
      flash[:success] = flash_message "created"
      redirect_to admin_root_url
    else
      flash[:failed] = flash_message "not_created"
      render :new
    end
  end

  def show
    @manager = @project.manager
    @assignees = Assignee.list_by_project @project
  end

  private
  def project_params
    params.require(:project).permit Project::PROJECT_ATTRIBUTES_PARAMS
  end
end
