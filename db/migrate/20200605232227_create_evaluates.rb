class CreateEvaluates < ActiveRecord::Migration[5.2]
  def change
    create_table :evaluates do |t|
      t.integer :evaluate_user_id, null: false
      t.integer :user_id, null: false
      t.integer :rate, null: false, default: 0
      t.timestamps
    end
     add_index :evaluates, [:user_id, :evaluate_user_id], unique: true
  end
end
