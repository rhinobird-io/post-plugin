class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.string :title
      t.text :body
      t.integer :creator_id
      t.timestamps
    end
    add_index :posts, :creator_id
  end
  def self.down
    drop_table :posts
  end
end
