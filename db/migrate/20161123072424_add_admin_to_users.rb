class AddAdminToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_root, :boolean
  end
end
