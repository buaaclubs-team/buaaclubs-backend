class AddIndexToEveryone < ActiveRecord::Migration
  def change
    add_index :articles, :title, unique: true
    add_index :users, :stu_num, unique: true
    add_index :clubs, :name, unique: true
    add_index :articles_users, [:user_id, :article_id], unique: true
    add_index :notes, [:user_id,:article_id], unique: true
  end
end
