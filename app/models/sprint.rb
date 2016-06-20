class Sprint < ActiveRecord::Base
  belongs_to :project

  has_many :assignees
  has_many :users, through: :assignees
  has_many :product_backlogs
  has_many :activities
  has_many :time_logs
  has_many :log_works
  has_many :master_sprints

  validates :name, presence: true
  validates :start_date, presence: true

  DEFAULT_MASTER_SPRINT = 3
  SPRINT_ATTRIBUTES_PARAMS = [:name, :description, :project_id, :start_date,
    user_ids: [], time_logs_attributes: [:id, :assignee_id, :lost_hour],
    log_works_attributes: [:id, :activity_id, :remaining_time],
    activities_attributes: [:id, :product_backlog_id, :subject, :description,
      :spent_time, :estimate, :user_id, :sprint_id],
    assignees_attributes: [:id, :work_hour],
    master_sprints_attributes: [:id, :date, :day]]

  after_create :build_master_sprint

  scope :list_by_user, ->user do
    joins(:assignees).where assignees: {user_id: user.id}
  end

  accepts_nested_attributes_for :time_logs
  accepts_nested_attributes_for :log_works
  accepts_nested_attributes_for :activities
  accepts_nested_attributes_for :master_sprints
  accepts_nested_attributes_for :assignees

  def include_user? current_user, project
    check_manager? current_user, project or include_assignee? current_user
  end

  def update_master_sprint
    self.master_sprints.each_with_index do |master_sprint, index|
      master_sprint.update_attributes date: self.start_date + index,
        day: index + 1
    end
  end

  def update_start_date
    self.update_attributes start_date: self.master_sprints.first.date
  end

  private
  def build_master_sprint
    if self.master_sprints.empty?
      DEFAULT_MASTER_SPRINT.times do |day|
        self.master_sprints.create date: self.start_date + day, day: day
      end
    end
  end

  def check_manager? current_user, project
    current_user.id == project.manager_id
  end

  def include_assignee? current_user
    self.assignees.map{|assignee| assignee.user_id}.include? current_user.id
  end
end
