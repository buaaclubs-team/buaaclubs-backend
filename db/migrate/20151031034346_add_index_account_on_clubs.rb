class AddIndexAccountOnClubs < ActiveRecord::Migration
  def change
    add_index :clubs, :club_account, unique: true
  end
end
