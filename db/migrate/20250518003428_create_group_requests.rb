# group_requestテーブル(中間テーブル)
class CreateGroupRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :group_requests do |t|
      t.integer :user_id, null: false
      t.integer :group_id, null: false
      # status: enumで状態管理，{0:申請前,1:申請中,2:許可済み,3:拒否}
      t.integer :status,   null: false, default: 0

      t.timestamps
    end
    # ユニーク制約設定（add_index :テーブル名, [:カラム名1, :カラム名2, :カラム名3, ...], unique: true）
    # user_idとgroup_idの組み合わせで設定し、同一ユーザーが同じグループに重複申請できないようにする
    add_index :group_requests, [:user_id, :group_id], unique: true
  end
end
