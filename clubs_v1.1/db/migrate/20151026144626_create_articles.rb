class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.belongs_to :club
      t.string :title
      t.string :abstract
      t.string :content

      t.timestamps null: false
    end

    create_table :articles_users,id: false do |t|
      t.belongs_to :user
      t.belongs_to :article
    end
  end
end
