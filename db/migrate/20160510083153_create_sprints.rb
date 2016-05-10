class CreateSprints < ActiveRecord::Migration
  def change
    create_table :sprints do |t|
      t.string :name
      t.string :description
      t.references :project, index: true, foregin: true
      
      t.timestamps null: false
    end
  end
end
