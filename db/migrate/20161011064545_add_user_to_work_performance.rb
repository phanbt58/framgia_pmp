class AddUserToWorkPerformance < ActiveRecord::Migration
  def change
    add_reference :work_performances, :user, index: true, foreign_key: true
  end
end
