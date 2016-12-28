class AddAssigneesSprint
  def initialize sprint, params
    @sprint = sprint
    @params = params
  end

  def create
    @assignees = @params[:member_ids].map do |member_id|
      @params[:user_id] = ProjectMember.find_by(id: member_id).user_id
      @params[:member_id] = member_id
      @sprint.assignees.build assignee_params
    end
    @assignees.map(&:save)
    @assignees
  end

  private
  def assignee_params
    @params.permit :project_id, :member_id, :user_id
  end
end
