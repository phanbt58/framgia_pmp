class CreateProjectPhases < ActiveRecord::Migration
  def change
    create_table :project_phases do |t|
      t.references :project
      t.references :phase
      t.timestamps null: false
    end
  end
end
