class Search < ApplicationRecord
  # アソシエーション定義（1:Nの「1」側）
  belongs_to :user  # 検索履歴は、1つのユーザーに紐づく（ユーザーごとの検索履歴を記録するため）
end
