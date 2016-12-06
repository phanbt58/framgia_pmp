class Api::MasterSprintsController < ApplicationController
  def show
    @master_sprint = MasterSprint.find_by id: params[:master_sprint_id]
    respond_to do |format|
      format.json do
        render json: {work_performances: @master_sprint.work_performances}
      end
    end
  end
end
