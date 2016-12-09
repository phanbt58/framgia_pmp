class ProjectMember < ActiveRecord::Base
  belongs_to :user
  belongs_to :project

  enum role: [:manager, :developer, :reporter, :reviewer, :temp]

  before_save :titleize_name

  private
  def titleize_name
    self.user_name = user_name.titleize
  end
end
