class AddmailverifycodeToUsers < ActiveRecord::Migration
  def change
	add_column :users, :email_verify_code, :integer
  end
end
