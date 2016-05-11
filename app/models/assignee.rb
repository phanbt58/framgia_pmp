class Assignee < ActiveRecord::Base
  belongs_to :sprint, class_name: Sprint.name
  belongs_to :user
end
