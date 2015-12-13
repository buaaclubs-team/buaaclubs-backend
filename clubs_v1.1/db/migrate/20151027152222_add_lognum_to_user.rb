class AddLognumToUser < ActiveRecord::Migration
  def change
    add_column :users, :log_num, :integer
  end
end
