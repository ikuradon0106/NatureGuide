# Categoryテーブル
class CreateCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :categories do |t|
      t.integer :post_id,       null: false
      # 以下は、enumで管理する、{0:other, 1:plant, 2:enviroment}、デフォルトは0とする
      t.integer :category_type, null: false

      t.timestamps
    end
  end
end
