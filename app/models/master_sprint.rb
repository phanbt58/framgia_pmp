class MasterSprint < ActiveRecord::Base
  has_many :time_logs
  has_many :log_works
end
