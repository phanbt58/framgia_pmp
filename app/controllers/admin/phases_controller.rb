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

  def update
    if @phase.update_attributes phase_params
      flash[:success] = flash_message "updated"
      redirect_to admin_project_phases_path(@project)
    else
      flash[:failed] = flash_message "not_updated"
      render :edit
    end
  end

  def destroy
    if @phase.destroy
      flash[:success] = flash_message "deleted"
    else
      flash[:success] = flash_message "not_deleted"
    end
    redirect_to admin_project_phases_url
  end

  private
  def phase_params
    params.require(:phase).permit Phase::PHASE_ATTRIBUTES_PARAMS
  end
end
