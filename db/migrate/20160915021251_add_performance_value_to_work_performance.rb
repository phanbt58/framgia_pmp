class AddPerformanceValueToWorkPerformance < ActiveRecord::Migration
  def change
    add_reference :work_performances, :sprint, index: true, foreign_key: true
    add_reference :work_performances, :item_performance, foreign_key: true
    add_reference :work_performances, :master_sprint, foreign_key: true
    add_reference :work_performances, :user, index: true, foreign_key: true

    add_column :work_performances, :performance_value, :float
  end
end
