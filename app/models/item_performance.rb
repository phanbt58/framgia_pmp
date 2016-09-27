class ItemPerformance < ActiveRecord::Base
  has_many :phase_items
  has_many :work_performances

  enum chart_type: [:burn_up, :burn_down]
end
