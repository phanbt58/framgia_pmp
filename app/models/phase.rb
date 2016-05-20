class Phase < ActiveRecord::Base
  has_many :work_performances

  PHASE_ATTRIBUTES_PARAMS = [:phase_name, :description]

  validates :phase_name, uniqueness: true
end
