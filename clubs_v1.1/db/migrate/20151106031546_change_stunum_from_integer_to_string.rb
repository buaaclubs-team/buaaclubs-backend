class ChangeStunumFromIntegerToString < ActiveRecord::Migration
  def change
      change_column :users, :stu_num, :string
  end
end
