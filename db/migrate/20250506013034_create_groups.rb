# groupテーブル
class CreateGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :groups do |t|
      t.integer :owner_id,   null: false
      t.string :group_name,  null: false
      t.text :description,   null: false
      t.string :group_image

      t.timestamps
    end
  end
end
