class AddClubaccountToClubs < ActiveRecord::Migration
  def change
      add_column :clubs, :club_account, :string

  end
end
