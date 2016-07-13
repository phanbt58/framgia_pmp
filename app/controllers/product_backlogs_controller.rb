class ProductBacklogsController < ApplicationController
  load_and_authorize_resource
  load_resource :project

  def index
    @sprints = Sprint.list_by_user current_user
    @product_backlogs = @project.product_backlogs
  end

  def destroy
    if @product_backlog.destroy
      respond_to do |format|
        format.html {redirect_to project_product_backlogs_path(@project)}
        format.json {render json: {}}
      end
    else
      respond_to do |format|
        format.html {redirect_to project_product_backlogs_path(@project)}
        format.json {render json: {}}
      end
    end
  end
end
