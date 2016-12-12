class CreateWorkPerformances < ActiveRecord::Migration
  def change
    create_table :work_performances do |t|
      t.references :phase, index: true, foreign: true
      t.string :description
      t.references :task

      t.timestamps null: false
    end
  end
end
