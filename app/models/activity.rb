class Activity < ActiveRecord::Base
  belongs_to :product_backlog
  belongs_to :sprint
  belongs_to :user
  belongs_to :assignee
  has_one :work_performance

  has_many :log_works
  after_create :create_log_works, :create_work_performance

  scope :fitler_log_works, ->sprint{includes(:log_works).where(sprint: sprint)}

  delegate :plan, :actual, to: :work_performance, prefix: true, allow_nil: true
  delegate :name, to: :user, prefix: true, allow_nil: true

  def get_remaining_activity
    self.log_works.any? ? self.log_works.pluck(:remaining_time).min : 0
  end

  private
  def create_log_works
    self.sprint.master_sprints.each do |master_sprint|
      master_sprint.log_works.create remaining_time: 0,
        sprint: sprint, activity: self
    end
  end

  def create_work_performance
    WorkPerformance.create activity: self, phase: Phase.first
  end
end


