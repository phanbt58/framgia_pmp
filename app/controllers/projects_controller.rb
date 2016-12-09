class ProjectsController < ApplicationController
  load_resource
  before_action :load_sprint, only: [:index, :show]

  def index
    @projects = current_user.projects
  end

  def show
    unless @project.include_assignee? current_user
      flash[:alert] = t "flashs.not_authorize"
      redirect_to root_path
    end
  end

  def edit
  end

  def update
    if @project.update_attributes project_params
      flash[:success] = flash_message :updated
      redirect_to project_path(@project)
    else
      flash.now[:failed] = flash_message :not_updated
      render :edit
    end
  end

  private
  def project_params
    params.require(:project).permit Project::PROJECT_ATTRIBUTES_PARAMS
  end

  def load_sprint
    @sprints = Sprint.list_by_user current_user
  end
end
