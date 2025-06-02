class CreateNotices < ActiveRecord::Migration[6.1]
  def change
    create_table :notices do |t|
      t.string :title,           null: false
      t.text :body,              null: false
      t.boolean :published,      null: false,  default: false
      t.datetime :published_at

      t.timestamps
    end
  end
end
