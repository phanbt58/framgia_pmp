class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.references :product_backlog
      t.references :sprint
      t.string :task_id
      t.integer :user_id
      t.integer :estimate
      t.integer :spent_time
      t.string :description
      t.string :subject

      t.timestamps null: false
    end
  end
end
