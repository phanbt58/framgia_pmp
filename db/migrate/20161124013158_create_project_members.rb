class CreateProjectMembers < ActiveRecord::Migration
  def change
    create_table :project_members do |t|
      t.string :user_name
      t.references :user
      t.references :project
      t.integer :role

      t.timestamps null: false
    end
  end
end
