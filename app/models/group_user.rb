class GroupUser < ApplicationRecord
  # アソシエーション定義（N:Nを中間テーブルを経由）
  belongs_to :user    # 1人のユーザーに紐づく
  belongs_to :group   # 1つのグループに紐づく
end
