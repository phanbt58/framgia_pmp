class CreateWorkPerformances < ActiveRecord::Migration
  def change
    create_table :work_performances do |t|
      t.references :phase, index: true, foreign: true
      t.string :description
      t.integer :plan
      t.integer :actual
      t.integer :spent_hour
      t.integer :burned_hour
      t.integer :estimated_story
      t.integer :burned_story
      t.integer :estimated_task
      t.references :activity

      t.timestamps null: false
    end
  end
end
