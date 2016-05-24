class Admin::PhasesController < ApplicationController
  load_and_authorize_resource

  def index
    @phase = Phase.new
  end

  def create
    if @phase.save
      flash[:success] = flash_message "created"
      redirect_to admin_phases_path
    else
      flash[:failed] = t "not_created"
      render :new
    end
  end

  def update
    if @phase.update_attributes phase_params
      flash[:success] = flash_message "updated"
      redirect_to admin_phases_path
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
    redirect_to admin_phases_path
  end

  private
  def phase_params
    params.require(:phase).permit Phase::PHASE_ATTRIBUTES_PARAMS
  end
end
