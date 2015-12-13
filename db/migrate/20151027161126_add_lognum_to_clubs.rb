class AddLognumToClubs < ActiveRecord::Migration
  def change
    add_column :clubs, :log_num, :integer
  end
end
