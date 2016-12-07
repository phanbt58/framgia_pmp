class LogWork < ActiveRecord::Base
  belongs_to :task
  belongs_to :master_sprint
  belongs_to :sprint
  after_update :update_actual_time, :update_remaining_time

  private
  def update_actual_time
    product_backlog = task.product_backlog
    actual_time = calculate_time product_backlog.id, sprint_id, :actual_time
    product_backlog.update_attributes actual: actual_time if product_backlog
  end

  def update_remaining_time
    product_backlog = task.product_backlog
    remaining = calculate_time product_backlog.id, sprint_id, :remaining_time
    product_backlog.update_attributes remaining: remaining if product_backlog
  end

  def calculate_time backlog_id, sprint_id, type
    tasks = Task.includes(:log_works).of_product_backlog_and_sprint(backlog_id,
      sprint_id)
    case type
    when :actual_time
      tasks.map(&:actual_time).reduce(0, :+)
    when :remaining_time
      tasks.map(&:remaining_time).reduce(0, :+)
    end
  end
end
