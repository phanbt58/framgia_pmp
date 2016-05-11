class CreateAssignees < ActiveRecord::Migration
  def change
    create_table :assignees do |t|
      t.references :user
      t.integer :project_id
      t.references :sprint

      t.timestamps null: false
    end
  end
end
