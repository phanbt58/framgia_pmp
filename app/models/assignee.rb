class Assignee < ActiveRecord::Base
  belongs_to :sprint, class_name: Sprint.name
  belongs_to :user

  scope :list_by_project, ->project{where project_id: project.id}

  delegate :name, to: :user, prefix: true, allow_nil: true
end
