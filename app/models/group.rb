class Group < ApplicationRecord
  # アソシエーション定義（N:Nを中間テーブルを経由）
  has_many :group_users,   dependent: :destroy       # 中間テーブルで結ばれている
  has_many :users,        through: :group_users      # groupとuserの中間テーブル

  # アソシエーション定義（N:Nを中間テーブルを経由）
  has_many :group_requests,   dependent: :destroy       # 中間テーブルで結ばれている
  has_many :users,        through: :group_requests     # groupとuserの中間テーブル

  # 検索ワードをもとに、Groupモデルのnameカラムに部分一致するユーザーを取得する
  # SQLのLIKE句を使用し、「名前に検索語が含まれているか」を判定する
  def self.search_for(word)
    where('group_name LIKE ?', "%#{word}%")
  end

  # ユーザーがowner.idか確認するメソッド
  def is_owned_by?(user)
    owner.id == user.id
  end
end
