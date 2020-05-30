class CreatePostWays < ActiveRecord::Migration[5.2]
  def change
    create_table :post_ways do |t|

      t.timestamps
    end
  end
end
