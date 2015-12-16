class AddPhoneverifyToUsers < ActiveRecord::Migration
  def change
	add_column :users, :phone_verify, :integer
  end
end
