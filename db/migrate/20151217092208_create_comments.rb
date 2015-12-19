class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.belongs_to :article
      t.integer :reply_id
      t.string :content
      t.integer :sender_id
      t.integer :sender_type

      t.timestamps null: false
    end
  end
end
