class AddUserheadToUsers < ActiveRecord::Migration
  def change
    add_column :users, :user_head, :string
  end
end
