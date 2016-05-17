class Admin::WorkPerformancesController < ApplicationController
  load_and_authorize_resource
  load_and_authorize_resource :project
  load_and_authorize_resource :sprint
  
  def index
    @phases = Phase.all
    @activities = @sprint.activities
  end
end
