class TimeLog < ActiveRecord::Base
  belongs_to :sprint
  belongs_to :user
  belongs_to :assignee
  belongs_to :master_sprint

  scope :total_lost_hour, ->sprint, work_date do
    where(sprint_id: sprint, work_date: work_date).sum(:lost_hour)
  end
end
