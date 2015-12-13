class CreateClubs < ActiveRecord::Migration
  def change
    create_table :clubs do |t|
      t.string :name
      t.string :password
      t.string :introduction
      t.string :head_url, null: true

      t.timestamps null: false
    end

    create_table :clubs_users, id: false do |t|
      t.belongs_to :club
      t.belongs_to :user
    end
  end

end
