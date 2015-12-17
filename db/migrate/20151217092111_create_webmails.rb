class CreateWebmails < ActiveRecord::Migration
  def change
    create_table :webmails do |t|
      t.integer :sender_id
      t.string :sender_name
      t.integer :receiver_id
      t.integer :receiver_type
      t.string :content
      t.integer :ifread

      t.timestamps null: false
    end
  end
end
