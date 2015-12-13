class AddEmailToUsers < ActiveRecord::Migration
  def change
	add_column :users, :email, :string, presence: true
  end
end
