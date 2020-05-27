class CreateCards < ActiveRecord::Migration[5.2]
  def change
    create_table :cards do |t|
      t.string :customer_id, null: false
      t.string :card_id,     null: false
      t.integer :user_id ,   foreign_key: true
      t.timestamps
    end
    add_index :cards, :card_id, unique: true
  end
end
