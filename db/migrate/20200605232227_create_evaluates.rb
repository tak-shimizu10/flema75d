class CreateEvaluates < ActiveRecord::Migration[5.2]
  def change
    create_table :evaluates do |t|
      t.integer :user_id, null: false
      t.integer :item_id, null: false
      t.integer :rate, null: false, default: 0
      t.string :comment, null: false
      t.timestamps
    end
    add_index :evaluates, [:user_id, :item_id], unique: true
  end
end
