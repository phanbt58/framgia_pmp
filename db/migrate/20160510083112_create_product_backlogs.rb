class CreateProductBacklogs < ActiveRecord::Migration
  def change
    create_table :product_backlogs do |t|
      t.integer :priority
      t.float :estimate
      t.float :actual
      t.float :remaining
      t.references :project, index: true, foreign: true
      t.references :sprint, index: true, foreign: true
      
      t.timestamps null: false
    end
  end
end
