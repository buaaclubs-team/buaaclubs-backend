class AddPhoneverifycodeToUsers < ActiveRecord::Migration
  def change
	add_column :users, :phone_verify_code, :integer
  end
end
