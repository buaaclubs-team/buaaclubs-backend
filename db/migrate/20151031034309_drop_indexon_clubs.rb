class DropIndexonClubs < ActiveRecord::Migration
  def up
    remove_index :clubs,column: :name
  end
end
