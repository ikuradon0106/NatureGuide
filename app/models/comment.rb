class Comment < ApplicationRecord
  # アソシエーション定義（1:Nの「1」側）
  belongs_to :user  # 各コメントは、1人のユーザーに紐づく
  belongs_to :post  # 各コメントは、1つの投稿に紐づく

  # バリテーション設定（空のコメントは投稿できない）
  validates :body, presence: true
end
