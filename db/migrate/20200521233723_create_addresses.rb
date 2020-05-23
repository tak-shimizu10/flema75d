class CreateAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :addresses do |t|
      t.string  :zipcode,              null: false, default: ""
      t.integer :prefecture_id,        null: false
      t.string  :city,                 null: false, default: ""
      t.string  :address,              null: false, default: ""
      t.string  :build_name           
      t.integer :user_id,              foreign_key: true
      t.timestamps
    end
  end
end