class Group < ApplicationRecord
  # アソシエーション定義（N:Nを中間テーブルを経由）
  has_many :user,        through: :group_users      # groupとuserの中間テーブル
end
