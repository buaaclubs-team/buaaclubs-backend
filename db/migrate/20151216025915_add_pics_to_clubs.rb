class AddPicsToClubs < ActiveRecord::Migration
  def change
	add_column :clubs, :pics, :string
  end
end
