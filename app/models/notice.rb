class Notice < ApplicationRecord
  # バリテーション設定（空のカラムになっていないかどうか）
  validates :title, presence: true
  validates :body, presence: true
end
