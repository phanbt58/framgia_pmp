class Api::WorkPerformancesController < Api::BaseController
  include WorkPerformanceHelper

  skip_before_action :verify_authenticity_token
  load_and_authorize_resource
  load_and_authorize_resource :project
  load_and_authorize_resource :sprint

  def index
    users = params[:users].present? ? params[:users] : ["0"]
    chart_type = params[:chart_type].to_i
    if chart_type == 2
      @work_performances = work_performance_for_burn_up @sprint, users
    else
      @work_performances = work_performances @sprint, users
    end
    render json: @work_performances
  end
end
