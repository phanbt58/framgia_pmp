class ProjectPhase < ActiveRecord::Base
  belongs_to :project
  belongs_to :phase
end
