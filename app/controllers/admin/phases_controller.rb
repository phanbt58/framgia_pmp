class Admin::PhasesController < ApplicationController
  load_and_authorize_resource
  load_and_authorize_resource :project
  load_and_authorize_resource :sprint

  def create
    if @phase.save
      flash[:success] = flash_message "created"
      redirect_to admin_project_sprint_work_performances_path(@project, @sprint)
    else
      flash[:failed] = t "flashs.messages.phase_not_create"
      render :new
    end
  end

  private
  def phase_params
    params.require(:phase).permit Phase::PHASE_ATTRIBUTES_PARAMS
  end
end
