class Group < ApplicationRecord
  # 投稿画像（ActiveStorageで1つの画像を添付可能）
  has_one_attached :group_image

  # アソシエーション定義（N:Nを中間テーブルを経由）
  has_many :group_users,   dependent: :destroy       # 中間テーブルで結ばれている
  has_many :users,        through: :group_users      # groupとuserの中間テーブル

  # アソシエーション定義（N:Nを中間テーブルを経由）
  has_many :group_requests,   dependent: :destroy       # 中間テーブルで結ばれている
  has_many :users,        through: :group_requests     # groupとuserの中間テーブル

  # 検索ワードをもとに、Groupモデルのnameカラムに部分一致するユーザーを取得する
  # SQLのLIKE句を使用し、「名前に検索語が含まれているか」を判定する
  def self.search_for(word)
    where("group_name LIKE ?", "%#{word}%")
  end

  # ユーザーがowner.idか確認するメソッド
  def is_owned_by?(user)
    owner.id == user.id
  end

  # コールバックを定義（creteアクションが実行された直後に、add_ownerメソッドを実行させる）
  after_create :add_owner
  def add_owner
    # group_usersテーブルにowner_idが含まれていない場合
    unless group_users.exists?(user_id: owner_id)
      # group_usersテーブルにowner_idを追加する
      group_users.create(user_id: owner_id)
    end
  end
end
