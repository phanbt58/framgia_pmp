class User < ActiveRecord::Base
  has_many :assignees
  has_many :time_logs
  has_many :activities
  has_many :projects
end
