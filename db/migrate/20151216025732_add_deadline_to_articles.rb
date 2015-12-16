class AddDeadlineToArticles < ActiveRecord::Migration
  def change
	add_column :articles, :deadline, :date
  end
end
