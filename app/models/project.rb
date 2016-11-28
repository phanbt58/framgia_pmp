class Project < ActiveRecord::Base
  belongs_to :manager, class_name: User.name

  has_many :sprints
  has_many :product_backlogs
  has_many :assignees
  has_many :users, through: :assignees
  has_many :project_phases
  has_many :phases, through: :project_phases
  has_many :phase_items, through: :phases
  has_many :item_performances, through: :phase_items
  has_many :members, class_name: ProjectMember.name, foreign_key: :project_id

  enum status: [:init, :inprogress, :finish, :close]

  after_create :create_product_backlog

  scope :list_by_assignee, ->user do
    joins(:assignees).where assignees: {user_id: user.id}
  end

  DEFAULT_PRODUCT_BACKLOG = 10
  PROJECT_ATTRIBUTES_PARAMS = [:name, :description, :manager_id, :start_date,
    :end_date, user_ids: []]

  validate :check_end_date, on: [:create, :update]

  delegate :name, to: :manager, prefix: true, allow_nil: true

  def include_assignee? current_user
    self.assignees.map{|assignee| assignee.user_id}.include? current_user.id
  end

  private
  def check_end_date
    if self.start_date.present? && self.end_date < self.start_date
      errors.add :end_date, I18n.t("errors.wrong_end_date")
    end
  end

  def create_product_backlog
    DEFAULT_PRODUCT_BACKLOG.times do |i|
      ProductBacklog.create(project_id: self.id)
    end
  end
end
