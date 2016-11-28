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

  private
  def load_sprint
    @sprints = Sprint.list_by_user current_user
  end
end
