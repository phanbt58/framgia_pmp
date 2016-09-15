class CreatePhaseItems < ActiveRecord::Migration
  def change
    create_table :phase_items do |t|
      t.references :phase
      t.references :item_performance
      t.timestamps null: false
    end
  end
end
