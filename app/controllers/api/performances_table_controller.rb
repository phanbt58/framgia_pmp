class Api::PerformancesTableController < Api::BaseController
  skip_before_action :verify_authenticity_token

  def index
    @phase = Phase.find_by id: params[:phase]
    @sprint = Sprint.find_by id: params[:sprint]
    respond_to do |format|
      format.html do
        render partial: "work_performances/data",
          locals: {phase: @phase, sprint: @sprint}
      end
    end
  end
end
