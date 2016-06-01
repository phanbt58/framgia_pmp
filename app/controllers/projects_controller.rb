class ProjectsController < ApplicationController
  load_resource
  before_action :load_sprint, only: [:index, :show]

  def index
    @projects = Project.list_by_assignee current_user
  end

  def show
    if @project.include_assignee? current_user
      @manager = @project.manager
      @assignees = Assignee.list_by_project @project
    else
      flash[:alert] = t "flashs.not_authorize"
      redirect_to root_path
    end
  end

  private
  def load_sprint
    @sprints = Sprint.list_by_user current_user
  end
end
