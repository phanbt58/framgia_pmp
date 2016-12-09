class Api::ProjectsController < ApplicationController
  load_and_authorize_resource

  def show
    @users = User.not_in_project(@project.members.pluck(:user_id))
      .search(params[:term])
    @members_to_add = @users.map do |user|
      {id: user.id, label: user.name, value: user.name}
    end
    respond_to do |format|
      format.json do
        render json: @members_to_add
      end
    end
  end
end
