class RemoveIndexFromWorkPerformance < ActiveRecord::Migration
  def change
    remove_index :work_performances, name: :work_perormance_index
    add_index :work_performances, [:sprint_id, :user_id, :task_id, :master_sprint_id], unique: true, name: :work_perormance_index
  end
end
