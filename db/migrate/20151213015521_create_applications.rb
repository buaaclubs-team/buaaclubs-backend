class CreateApplications < ActiveRecord::Migration
  def change
    create_table :applications do |t|
      t.belongs_to :user      
      t.belongs_to :club
      t.string :reason
      t.integer :accept

      t.timestamps null: false
    end
  end
end
