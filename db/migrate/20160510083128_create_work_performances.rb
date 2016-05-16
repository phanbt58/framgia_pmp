class CreateWorkPerformances < ActiveRecord::Migration
  def change
    create_table :work_performances do |t|
      t.references :phase, index: true, foreign: true
      t.string :description
      t.integer :plan
      t.integer :actual
      t.references :activity

      t.timestamps null: false
    end
  end
end
