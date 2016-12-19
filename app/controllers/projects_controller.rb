class ProjectsController < ApplicationController
  load_resource
  before_action :load_sprint, only: [:index, :show]
  before_action :load_member_not_in_project, only: [:edit]

  autocomplete :user, :name, full: true, extra_data: [:id]

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
    @sprints = @project.sprints if @project
  end

  def load_member_not_in_project
    @users = User.not_in_project(@project.members.pluck(:id))
  end
end
