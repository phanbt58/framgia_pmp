class Admin::SprintsController < ApplicationController
  load_and_authorize_resource
  load_and_authorize_resource :project

  def create
    if @sprint.save
      flash[:success] = flash_message "created"
      redirect_to admin_project_path(@project)
    else
      flash[:failed] = flash_messages "not_created"
      render :new
    end
  end

  private
  def sprint_params
    params.require(:sprint).permit Sprint::SPRINT_ATTRIBUTES_PARAMS
  end
end
