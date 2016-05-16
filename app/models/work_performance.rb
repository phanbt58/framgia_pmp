class WorkPerformance < ActiveRecord::Base
  belongs_to :phase
  belongs_to :activity
end
