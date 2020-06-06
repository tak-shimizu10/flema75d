class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.string :name, null: false
      t.text :detail, null: false
      t.integer :price, null: false
      t.integer :pay_side, null: false, default: 0
      t.integer :post_date, null: false, default: 0
      t.integer :status, null: false, default: 0
      t.integer :prefecture_id, null: false, default: 0
      t.integer :post_way_id, null: false, default: 0
      t.integer :brand_id
      t.integer :category_id, foreign_key: true
      t.integer :user_id, foreign_key: true
      t.integer :situation, null: false, default: 0
      t.integer :buyer_id
      t.timestamps
    end
  end
end
