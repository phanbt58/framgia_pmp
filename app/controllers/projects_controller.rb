class ProjectsController < ApplicationController

  def index
    @projects = Project.list_by_assignee current_user
    @sprints = Sprint.list_by_user current_user
  end

  def show
    @project = Project.find params[:id]
    @manager = @project.manager
    @assignees = Assignee.list_by_project @project
  end
end
