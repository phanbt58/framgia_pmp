class SprintsController < ApplicationController
  load_resource
  load_resource :project

  def show
    @sprints = Sprint.list_by_user current_user
  end
end
