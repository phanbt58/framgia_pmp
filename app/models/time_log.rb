class TimeLog < ActiveRecord::Base
  belongs_to :sprint
  belongs_to :user
  belongs_to :assignee
  belongs_to :master_sprint

  scope :total_lost_hour, ->master_sprint do
    where(master_sprint_id: master_sprint).sum(:lost_hour)
  end
end
