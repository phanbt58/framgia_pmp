class AddHrTokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :hr_token, :string
    add_column :users, :hr_email, :string
  end
end
