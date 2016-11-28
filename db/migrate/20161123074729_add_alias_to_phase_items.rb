class AddAliasToPhaseItems < ActiveRecord::Migration
  def change
    add_column :phase_items, :alias, :string
  end
end
