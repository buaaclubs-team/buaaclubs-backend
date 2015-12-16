class DropTableWebmailAndComment < ActiveRecord::Migration
  def up
    drop_table :comments
    drop_table :webmails
  end
end
