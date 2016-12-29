class AssigneesController < ApplicationController
  load_resource :project
  load_resource :sprint

  def create
    @assignees = AddAssigneesSprint.new(@sprint, params).create
    respond_to do |format|
      format.json do
        render json: {
          content: render_to_string(
            partial: "/sprints/new_assignee", formats: "html", layout: false,
            locals: {row_number: @sprint.assignees.size, assignees: @assignees}
          )
        }
      end
    end
  end

  def destroy
    @assignee = Assignee.find_by id: params[:id]
    if @assignee.destroy
      respond_to do |format|
        format.json do
          render json: {
            member_id: @assignee.member_id,
            user_name: @assignee.user_name
          }
        end
      end
    end
  end
end
