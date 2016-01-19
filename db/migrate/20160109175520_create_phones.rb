class CreatePhones < ActiveRecord::Migration
  def change
    create_table :phones do |t|
      t.string :phone_num
      t.integer :phone_verify_num

      t.timestamps null: false
    end
  end
end
