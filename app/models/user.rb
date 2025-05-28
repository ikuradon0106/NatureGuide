class User < ApplicationRecord
  # Deviseによる認証機能の組み込み
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # プロフィール画像（ActiveStorageで1つの画像を添付可能）
  has_one_attached :user_image

  # アソシエーション定義（1:Nの「N」側）
  has_many :posts,        dependent: :destroy        # 投稿機能
  has_many :comments,     dependent: :destroy        # コメント機能
  has_many :searches,     dependent: :destroy        # 検索履歴

  # アソシエーション定義（N:Nを中間テーブルを経由）
  has_many :group_users,   dependent: :destroy       # 中間テーブルで結ばれている
  has_many :groups,        through: :group_users     # groupとuserの中間テーブル

  # アソシエーション定義（N:Nを中間テーブルを経由）
  has_many :group_requests,   dependent: :destroy       # 中間テーブルで結ばれている
  has_many :groups,        through: :group_requests     # groupとuserの中間テーブル

  # バリテーション設定（空のカラムになっていないかどうか）
  validates :email, :nickname, presence: true

  # 検索ワードをもとに、Userモデルのnicknameカラムに部分一致するユーザーを取得する
  # SQLのLIKE句を使用し、「nicknameに検索語が含まれているか」を判定する
  def self.search_for(word)
    where("nickname LIKE ?", "%#{word}%")
  end
end
