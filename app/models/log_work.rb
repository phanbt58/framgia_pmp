class LogWork < ActiveRecord::Base
  belongs_to :task
  belongs_to :master_sprint
  belongs_to :sprint
  after_update :update_actual_time, :update_remaining_time

  private
  def update_actual_time
    product_backlog = task.product_backlog
    actual_time = Task.includes(:log_works)
      .of_product_backlog_and_sprint(product_backlog.id, sprint.id).map do |task|
      task.log_works.first.remaining_time
    end.sum rescue 0
    product_backlog.update_attributes actual: actual_time if product_backlog
  end

  def update_remaining_time
    product_backlog = task.product_backlog
    remaining = Task.includes(:log_works)
      .of_product_backlog_and_sprint(product_backlog.id, sprint.id).map do |task|
      task.log_works.last.remaining_time
    end.sum rescue 0
    product_backlog.update_attributes remaining: remaining if product_backlog
  end
end
