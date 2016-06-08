class Admin::ProjectsController < ApplicationController
  load_and_authorize_resource
  before_action :load_assignee, only: [:new, :edit, :show, :update]

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

  def update
    if @project.update_attributes project_params
      flash[:success] = flash_message "updated"
      redirect_to admin_project_path(@project)
    else
      flash[:failed] = flash_message "not_updated"
      render :edit
    end
  end

  def destroy
    if @project.destroy
      flash[:success] = flash_message "deleted"
    else
      flash[:success] = flash_message "not_deleted"
    end
    redirect_to admin_root_path
  end

  private
  def project_params
    params.require(:project).permit Project::PROJECT_ATTRIBUTES_PARAMS
  end

  def load_assignee
    @users = User.fitler_by_role_not_manager
    @assignee = Assignee.new
  end
end
