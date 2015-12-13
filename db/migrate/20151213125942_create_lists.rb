class CreateLists < ActiveRecord::Migration
  def change
    create_table :lists do |t|
      t.belongs_to :user
      t.belongs_to :club 
      t.timestamps null: false
    end
  end
end
