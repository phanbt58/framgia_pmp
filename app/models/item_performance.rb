class ItemPerformance < ActiveRecord::Base
  has_many :phase_items
  has_many :work_performances
end
