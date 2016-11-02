class MasterSprint < ActiveRecord::Base
  belongs_to :sprint

  has_many :time_logs, dependent: :destroy
  has_many :log_works, dependent: :destroy
  has_many :work_performances, dependent: :destroy

  before_create :set_date_and_day
  after_create :create_log_times_and_log_works
  after_destroy :update_day

  scope :in_today, ->{where date: Date.today}
  scope :after_this_day, ->day{where"day > ?", day}

  private
  def create_log_times_and_log_works
    sprint.assignees.each do |assignee|
      assignee.time_logs.create master_sprint: self, sprint: sprint
    end

    sprint.tasks.each do |task|
      task.log_works.create master_sprint: self,
        remaining_time: task.log_works.last.remaining_time, sprint: sprint
    end
  end

  def set_date_and_day
    if sprint.master_sprints.count == 0
      self.day = 1
      self.date = sprint.start_date
    else
      self.day = sprint.master_sprints.size + 1
      self.date = sprint.master_sprints.last.date + 1 if self.date.nil?
    end
  end

  def update_day
    sprint.master_sprints.after_this_day(self.day).update_all("day = day - 1")
  end
end
