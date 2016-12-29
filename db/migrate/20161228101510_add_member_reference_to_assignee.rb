class AddMemberReferenceToAssignee < ActiveRecord::Migration
  def change
    add_column :assignees, :member_id, :integer
  end
end
