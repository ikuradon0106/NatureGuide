class Group < ApplicationRecord
  # アソシエーション定義（N:Nを中間テーブルを経由）
  has_many :user,        through: :group_users      # groupとuserの中間テーブル

  # 検索ワードをもとに、Groupモデルのnameカラムに部分一致するユーザーを取得する
  # SQLのLIKE句を使用し、「名前に検索語が含まれているか」を判定する
  def self.search_for(word)
    where('group_name LIKE ?', "%#{word}%")
  end
end
