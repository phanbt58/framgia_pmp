class ProductBacklog < ActiveRecord::Base
  belongs_to :project
  belongs_to :sprint

  has_many :tasks

  delegate :name, to: :project, prefix: true
  delegate :name, :id, to: :sprint, prefix: true, allow_nil: true

  scope :with_ids, ->ids {where id: ids}

  def total_estimation_time
    estimate = Task.includes(:log_works)
      .of_product_backlog_and_sprint(id, sprint_id).map do |task|
      task.log_works.first.remaining_time
    end.sum rescue 0
    estimate
  end

  def total_remaining_time
    if self.tasks.any?
      remaining = Task.includes(:log_works)
        .of_product_backlog_and_sprint(id, sprint_id).map do |task|
        task.log_works.last.remaining_time
      end.sum rescue 0
      self.update_attributes remaining: remaining
      remaining
    end
  end

  def calculate_actual_time
    if self.tasks.any?
      actual_time = total_estimation_time
      self.update_attributes actual: actual_time
      actual_time
    end
  end
end
