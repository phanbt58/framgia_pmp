class Api::WorkPerformancesController < Api::BaseController
  include WorkPerformanceHelper

  skip_before_action :verify_authenticity_token
  load_and_authorize_resource
  load_and_authorize_resource :project
  load_and_authorize_resource :sprint

  def index
    users = params[:users].present? ? params[:users] : ["0"]

    @work_performances = work_performances @sprint, users, params[:chart_type],
      params[:view_type]
    render json: @work_performances
  end
end
