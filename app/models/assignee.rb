class Assignee < ActiveRecord::Base
  belongs_to :sprint, class_name: Sprint.name
  belongs_to :user
  belongs_to :project
  has_many :time_logs

  scope :list_by_project, ->project{where project_id: project.id}
  scope :not_assign_sprint, ->{where "sprint_id IS ?", nil}

  delegate :name, to: :user, prefix: true, allow_nil: true

  after_create :create_time_logs

  private
  def create_time_logs
    return if self.sprint.nil?
    self.sprint.master_sprints.each do |master_sprint|
      master_sprint.time_logs.create sprint: sprint, assignee: self
    end
  end
end
