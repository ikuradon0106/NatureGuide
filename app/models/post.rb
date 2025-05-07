class Post < ApplicationRecord
  # アソシエーション定義（1:Nの「N」側）
  has_many :comments,        dependent: :destroy        # コメント機能
  has_many :categories,      dependent: :destroy        # カテゴリー機能

  # アソシエーション定義（1:Nの「1」側）
  belongs_to :user  # 各投稿は、1人のユーザーに紐づく

  # バリテーション設定（空のカラムになっていないかどうか）
  validates :title, presence: true, length: { maximum: 100 }
  validates :body,  presence: true
end
