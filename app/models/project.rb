class Project < ActiveRecord::Base
  belongs_to :manager, class_name: User.name

  has_many :sprints
  has_many :product_backlogs
  has_many :assignees
  has_many :users, through: :assignees

  scope :list_by_assignee, ->user do
    joins(:assignees).where assignees: {user_id: user.id}
  end
  PROJECT_ATTRIBUTES_PARAMS = [:name, :description, :manager_id, :start_date,
    :end_date, user_ids: []]

  validate :check_end_date, on: [:create, :update]

  private
  def check_end_date
    if self.start_date.present? && self.end_date < self.start_date
      errors.add :end_date, I18n.t("errors.wrong_end_date")
    end
  end
end
