class AddTypeToArticles < ActiveRecord::Migration
  def change
	add_column :articles, :type, :integer
  end
end
