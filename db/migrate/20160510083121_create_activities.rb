class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.references :product_backlog, index: true, foreign_key: true
      t.string :subject
      t.string :description
      t.integer :spent_time
      t.integer :estimate
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
