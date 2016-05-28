class MasterSprint < ActiveRecord::Base
  belongs_to :sprint
  
  has_many :time_logs
  has_many :log_works
end
