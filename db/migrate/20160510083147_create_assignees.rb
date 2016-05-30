class CreateAssignees < ActiveRecord::Migration
  def change
    create_table :assignees do |t|
      t.references :user
      t.integer :project_id
      t.integer :work_hour
      t.references :sprint

      t.timestamps null: false
    end
  end
end
