class AddStoryIdToProductBacklogs < ActiveRecord::Migration
  def change
    add_column :product_backlogs, :story_id, :string
  end
end
