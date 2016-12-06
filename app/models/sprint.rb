class Sprint < ActiveRecord::Base
  belongs_to :project

  has_many :assignees, dependent: :destroy
  has_many :users, through: :assignees, before_remove: :destroy_time_logs
  has_many :time_logs, dependent: :destroy
  has_many :product_backlogs
  has_many :days, class_name: MasterSprint.name, foreign_key: :sprint_id
  has_many :tasks, dependent: :destroy
  has_many :log_works, dependent: :destroy
  has_many :master_sprints, dependent: :destroy
  has_many :item_performances, through: :project
  has_many :phase_items, through: :project
  has_many :work_performances, dependent: :destroy

  delegate :phases, to: :project, prefix: true, allow_nil: true

  validates :start_date, presence: true

  DEFAULT_MASTER_SPRINT = 10
  SPRINT_ATTRIBUTES_PARAMS = [:description, :project_id, :start_date,
    user_ids: [], time_logs_attributes: [:id, :assignee_id, :lost_hour],
    log_works_attributes: [:id, :task_id, :remaining_time],
    tasks_attributes: [:id, :product_backlog_id, :task_id, :subject,
      :description, :spent_time, :estimate, :user_id, :sprint_id],
    assignees_attributes: [:id, :work_hour],
    master_sprints_attributes: [:id, :date, :day]]

  after_create :build_master_sprint, :create_default_tasks
  after_update :update_master_sprint

  scope :list_by_user, ->user do
    joins(:assignees).where assignees: {user_id: user.id}
  end

  accepts_nested_attributes_for :time_logs
  accepts_nested_attributes_for :log_works
  accepts_nested_attributes_for :tasks
  accepts_nested_attributes_for :master_sprints
  accepts_nested_attributes_for :assignees

  def include_user? current_user, project
    check_manager? current_user, project || include_assignee? current_user
  end

  def update_start_date
    self.update_attributes start_date: self.master_sprints.first.date
  end

  def end_date
    self.days.last.date
  end

  def create_name
    index = self.project.sprints.count + 1
    self.name = I18n.t("sprints.sprint") + index.to_s
  end

  private
  def build_master_sprint
    if self.master_sprints.empty?
      weekend_day = 0
      DEFAULT_MASTER_SPRINT.times do |day|
        date, weekend_day = set_day_sprint weekend_day, day
        self.days.create date: date, day: day
      end
    end
  end

  def update_master_sprint
    weekend_day = 0
    self.master_sprints.each_with_index do |master_sprint, index|
      date, weekend_day = set_day_sprint weekend_day, index
      master_sprint.update_attributes date: date, day: index + 1
    end
  end

  def set_day_sprint weekend_day, day
    date = self.start_date + weekend_day + day
    if date.saturday?
      date = date + 2.day
      weekend_day += 2
    end
    [date, weekend_day]
  end

  def check_manager? current_user, project
    project.managers.map{|member| member.user_id}.include? current_user.id
  end

  def include_assignee? current_user
    self.assignees.map{|assignee| assignee.user_id}.include? current_user.id
  end

  def destroy_time_logs user
    user.assignees.find_by(sprint_id: self.id).time_logs.destroy_all
  end

  def create_default_tasks
    10.times do |i|
      Task.create(sprint_id: self.id)
    end
  end
end
