class TimeLog < ActiveRecord::Base
  belongs_to :sprint
  belongs_to :user
end
