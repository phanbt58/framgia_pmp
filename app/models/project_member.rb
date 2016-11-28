class ProjectMember < ActiveRecord::Base
  belongs_to :user
  belongs_to :project

  enum role: [:manager, :developer, :reporter, :reviewer, :temp]
end
