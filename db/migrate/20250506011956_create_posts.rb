# Postテーブル
class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.integer :user_id,       null: false
      t.string :title,          null: false
      t.string :image,          null: false
      t.text :body,             null: false
      t.string :location_name,  null: false
      # 9:全体の桁数(precision)、6:小数点以下の桁数(scale)で桁数の指定
      t.decimal :latitude,      null: false, precision: 9, scale: 6
      t.decimal :longitude,     null: false, precision: 9, scale: 6

      t.timestamps
    end
  end
end
