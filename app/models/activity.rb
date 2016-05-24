class Activity < ActiveRecord::Base
  belongs_to :product_backlog
  belongs_to :sprint
  belongs_to :user

  has_one :work_performance

  has_many :log_works

  scope :fitler_log_works, ->sprint{includes(:log_works).where(sprint: sprint)}

  delegate :plan, :actual, to: :work_performance, prefix: true, allow_nil: true
  delegate :name, to: :user, prefix: true, allow_nil: true
end
