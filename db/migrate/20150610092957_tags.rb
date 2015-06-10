class Tags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name
      t.string :color
      t.timestamps
    end

    create_table :posts_tags, id: false do |t|
      t.belongs_to :post, index: true
      t.belongs_to :tag, index: true
    end

    add_index :tags, :name, unique: true
  end
end
