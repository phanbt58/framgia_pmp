class ProductBacklogsController < ApplicationController
  load_resource :project
  
  def index
    @sprints = Sprint.list_by_user current_user
  end
end
