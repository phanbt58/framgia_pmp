class CreateItemPerformances < ActiveRecord::Migration
  def change
    create_table :item_performances do |t|
      t.integer :performance_name
      t.text :description
      t.timestamps null: false
    end
  end
end
