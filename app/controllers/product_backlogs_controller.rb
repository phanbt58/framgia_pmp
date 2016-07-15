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

  def create
    @sprints = Sprint.list_by_user current_user
    @product_backlog = @project.product_backlogs.build
    if @product_backlog.save
      @row_number = @project.product_backlogs.size.pred
    end
    respond_to do |format|
      format.json do
        render json: {
          row_number: @row_number,
          content: render_to_string(
            partial: "product_backlogs/row",
            layout: false,
            formats: "html"
          )
        }
      end
    end
  end
end
