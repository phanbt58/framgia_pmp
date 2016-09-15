class CreateItemPerformances < ActiveRecord::Migration
  def change
    create_table :item_performances do |t|
      t.string :name
      t.text :description
      t.timestamps null: false
    end
  end
end
