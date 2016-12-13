class AddIndexToWorkPerformance < ActiveRecord::Migration
  def change
    add_index :work_performances, [:phase_id, :sprint_id, :task_id,
      :master_sprint_id], unique: true, name: :work_perormance_index
  end
end
