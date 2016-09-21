class AddVisibleToPhaseItem < ActiveRecord::Migration
  def change
    add_column :phase_items, :visible, :boolean
  end
end
