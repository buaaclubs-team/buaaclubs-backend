class CreateWebmails < ActiveRecord::Migration
  def change
    create_table :webmails do |t|
	t.integer :sender_id
	t.string :sender_name
	t.string :receiver_id
	t.integer :receiver_type
	t.string :string
	t.integer :ifread

	t.timestaps
    end
  end
end
