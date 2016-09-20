class WorkPerformance < ActiveRecord::Base
  belongs_to :phase
  belongs_to :activity
  belongs_to :item_performance
  belongs_to :sprint
  belongs_to :master_sprint

  ATTRIBUTES_PARAMS = [:description, :plan, :actual, :spent_hour,
    :burned_hour, :estimated_story, :burned_story, :estimated_task]

  scope :performances_in_day, ->(users_id, item, day) do
    where assignee_id: users_id, item_performance_id: item.id, master_sprint_id: day.id
  end
end
