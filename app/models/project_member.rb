class ProjectMember < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  has_many :assignees

  enum role: [:manager, :developer, :reporter, :reviewer, :temp]

  before_save :titleize_name

  scope :not_in_sprint, ->ids{where.not id: ids}

  private
  def titleize_name
    self.user_name = user_name.titleize
  end
end
