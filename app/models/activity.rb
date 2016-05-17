class Activity < ActiveRecord::Base
  belongs_to :product_backlog
  belongs_to :sprint
  belongs_to :user
  
  has_one :work_performance

  delegate :plan, :actual, to: :work_performance, prefix: true, allow_nil: true
  delegate :name, to: :user, prefix: true, allow_nil: true
end
