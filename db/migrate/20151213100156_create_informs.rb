class CreateInforms < ActiveRecord::Migration
  def change
    create_table :informs do |t|
      t.belongs_to :club
      
      t.string :users     
      t.string :content
      t.integer :type

      t.timestamps null: false
    end
  end
end
