class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :stu_num
      t.string :name
      t.string :password
      t.string :phone_num, limit: 11

      t.timestamps null: false
    end
  end
end
