class AddChartTypeToItemPerformances < ActiveRecord::Migration
  def change
    add_column :item_performances, :chart_type, :float
  end
end
