class CreateLogWorks < ActiveRecord::Migration
  def change
    create_table :log_works do |t|
      t.references :task, index: true, foreign_key: true
      t.integer :remaining_time
      t.references :sprint, index: true, foregin: true
      t.references :master_sprint, index: true, foreign: true

      t.timestamps null: false
    end
  end
end
