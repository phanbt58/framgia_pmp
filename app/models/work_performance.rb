class WorkPerformance < ActiveRecord::Base
  belongs_to :phase
  belongs_to :activity

  ATTRIBUTES_PARAMS = [:description, :plan, :actual]
end
