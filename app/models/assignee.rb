class Assignee < ActiveRecord::Base
  belongs_to :sprint, class_name: Sprint.name
  belongs_to :user
  belongs_to :project
  belongs_to :member, class_name: ProjectMember.name
  has_many :time_logs

  scope :list_by_project, ->project{where project_id: project.id}
  scope :not_assign_sprint, ->{where "sprint_id IS ?", nil}
  scope :can_get_task, -> do
    joins(:member).where.not("project_members.role IN (2,3)")
  end

  after_create :create_time_logs, :update_user_name

  private
  def create_time_logs
    return if self.sprint.nil?
    self.sprint.master_sprints.each do |master_sprint|
      master_sprint.time_logs.create sprint: sprint, assignee: self
    end
  end

  def update_user_name
    self.update_attributes user_name: member.user_name
  end
end
