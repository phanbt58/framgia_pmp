class ProjectsController < ApplicationController
  load_resource :project
  before_action :load_sprint, only: [:index, :show]

  def index
    @projects = Project.list_by_assignee current_user
  end

  def show
    @manager = @project.manager
    @assignees = Assignee.list_by_project @project
  end

  private
  def load_sprint
    @sprints = Sprint.list_by_user current_user
  end
end
