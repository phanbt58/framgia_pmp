class AddStatusToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :status, :integer
    remove_column :projects, :manager_id, :integer
  end
end
