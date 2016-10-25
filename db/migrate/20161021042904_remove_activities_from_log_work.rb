class RemoveActivitiesFromLogWork < ActiveRecord::Migration
  def change
    remove_reference :log_works, :activity, index: true, foreign_key: true
    add_reference :log_works, :task, index: true, foreign_key: true
  end
end
