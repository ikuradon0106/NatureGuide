# Postテーブル
class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.integer :user_id,       null: false
      t.string :title,          null: false
      t.string :image           
      t.text :body,             null: false
      t.string :address,        null: false, default: ""
      t.float :latitude,        null: false, default: 0
      t.float :longitude,       null: false, default: 0

      t.timestamps
    end
  end
end
