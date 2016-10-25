class RemoveActivitiesFromWorkPerformance < ActiveRecord::Migration
  def change
    remove_reference :work_performances, :activity
    add_reference :work_performances, :task
  end
end
