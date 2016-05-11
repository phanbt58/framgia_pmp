class ProjectsController < ApplicationController
  def index
    if current_user.manager?
      @projects = Project.all
    else
      @projects = Project.list_by_assignee current_user
    end
  end
end
