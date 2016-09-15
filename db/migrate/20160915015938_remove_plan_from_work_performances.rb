class RemovePlanFromWorkPerformances < ActiveRecord::Migration
  def change
    remove_column :work_performances, :plan, :integer
    remove_column :work_performances, :actual, :integer
    remove_column :work_performances, :spent_hour, :integer
    remove_column :work_performances, :burned_hour, :integer
    remove_column :work_performances, :estimated_story, :integer
    remove_column :work_performances, :burned_story, :integer
    remove_column :work_performances, :estimated_task, :integer
  end
end
