class AddUserNameToAssignee < ActiveRecord::Migration
  def change
    add_column :assignees, :user_name, :string
  end
end
