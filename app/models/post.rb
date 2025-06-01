class Post < ApplicationRecord
  # 投稿画像（ActiveStorageで1つの画像を添付可能）
  has_one_attached :image

  # アソシエーション定義（1:Nの「N」側）
  has_many :comments,        dependent: :destroy        # コメント機能
  has_many :categories,      dependent: :destroy        # カテゴリー機能
  has_many :tags,            dependent: :destroy        # APIのタグ機能
  
  # アソシエーション定義（1:Nの「1」側）
  belongs_to :user  # 各投稿は、1人のユーザーに紐づく

  # バリテーション設定（空のカラムになっていないかどうか）
  validates :title, presence: true, length: { maximum: 100 }
  validates :body,  presence: true
  validates :address, presence: true

  # addressカラムの内容を緯度・経度に変換することを指定
  geocoded_by :address

  # バリデーションの実行後に変換処理を実行して、latitudeカラム・longitudeカラムに緯度・経度の値が入力
  after_validation :geocode


  # 画像がなければ、保存画像を表示
  def get_image
    if image.attached?
      image
    else
      nil
    end
  end

  # 検索ワードをもとに、Postモデルのnameカラムに部分一致するユーザーを取得する
  # SQLのLIKE句を使用し、「名前に検索語が含まれているか」を判定する
  def self.search_for(word)
    where("title LIKE ?", "%#{word}%")
  end
end
