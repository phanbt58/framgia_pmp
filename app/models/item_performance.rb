class ItemPerformance < ActiveRecord::Base
  has_many :phase_items
  has_many :work_performances

  enum chart_type: [:burn_up, :burn_down]
  enum performance_name: [:estimate_task, :spent_time, :burn_value, :estimate_story,
    :burn_story, :execute]

  scope :list_by_chart_type, -> type {where chart_type: type}
end
