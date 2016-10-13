class RemoveAssigneeFromWorkPerformance < ActiveRecord::Migration
  def change
    remove_reference :work_performances, :assignee, index: true, foreign_key: true
  end
end
