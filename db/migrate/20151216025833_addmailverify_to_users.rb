class AddmailverifyToUsers < ActiveRecord::Migration
  def change
	add_column :users, :email_verify, :integer
  end
end
