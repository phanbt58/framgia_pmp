class Api::ActivitiesController < ApplicationController
  load_resource :project
  load_resource :sprint

  def index
    if params[:user_id]
      respond_to do |format|
        format.json {
          render json: {activities: Activity.of_user_in_sprint(params[:user_id], @sprint)}
        }
      end
    end
  end
end
