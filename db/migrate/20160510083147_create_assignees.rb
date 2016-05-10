class CreateAssignees < ActiveRecord::Migration
  def change
    create_table :assignees do |t|
      t.references :user, index: true, foreign: true
      t.integer :project_id
      t.references :sprint, index: true, foreign: true
      
      t.timestamps null: false
    end
  end
end
