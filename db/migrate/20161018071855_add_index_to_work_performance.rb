class AddIndexToWorkPerformance < ActiveRecord::Migration
  def change
    add_index :work_performances, [:sprint_id, :user_id, :activity_id, :master_sprint_id], unique: true, name: :work_perormance_index
  end
end
