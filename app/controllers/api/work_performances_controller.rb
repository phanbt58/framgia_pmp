class Api::WorkPerformancesController < Api::BaseController
  include WorkPerformanceHelper

  skip_before_action :verify_authenticity_token
  load_and_authorize_resource
  load_and_authorize_resource :project
  load_and_authorize_resource :sprint

  def index
    @work_performances = work_performances @sprint, @sprint.users.pluck(:id)
    render json: @work_performances
  end
end
