class CreateClubsAndUsers < ActiveRecord::Migration
  def change
    create_table :clubs_users do |t|
	t.belongs_to :user
        t.belongs_to :club
    end
  end
end
