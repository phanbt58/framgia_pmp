class CreateSystemLogs < ActiveRecord::Migration
  def change
    create_table :system_logs do |t|
      t.string :description
      t.integer :user_id
      t.string :action_type
      t.integer :target_id
      
      t.timestamps null: false
    end
  end
end
