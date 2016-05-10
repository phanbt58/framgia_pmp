class CreateWorkPerformanceData < ActiveRecord::Migration
  def change
    create_table :work_performance_data do |t|
      t.references :phase, index: true, foreign: true
      t.string :description
      t.integer :plan
      t.integer :actual
      t.references :activity, index: true, foreign: true
      
      t.timestamps null: false
    end
  end
end
