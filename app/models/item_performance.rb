class ItemPerformance < ActiveRecord::Base
  has_many :phase_items
  has_many :work_performances

  enum chart_type: [:burn_up, :burn_down]

  scope :list_by_chart_type, -> type {where chart_type: type}
end
