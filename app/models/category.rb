class Category < ApplicationRecord
  # アソシエーション定義（1:Nの「1」側）
  belongs_to :post  # 各カテゴリーは、1つの投稿に紐づく
end
