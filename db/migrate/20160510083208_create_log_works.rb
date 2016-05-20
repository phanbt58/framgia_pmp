class CreateLogWorks < ActiveRecord::Migration
  def change
    create_table :log_works do |t|
      t.references :activity, index: true, foreign_key: true
      t.integer :remaining_time
      t.date :day

      t.timestamps null: false
    end
  end
end
