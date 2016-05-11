class Project < ActiveRecord::Base
  belongs_to :manager, class_name: User.name

  has_many :sprints
  has_many :product_backlogs

  scope :list_by_assignee, ->user do
    joins(sprints: :assignees).where assignees: {user_id: user.id}
  end
end
