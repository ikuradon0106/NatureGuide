class GroupRequest < ApplicationRecord
  # アソシエーション定義（N:Nを中間テーブルを経由）
  belongs_to :user    #1人のユーザーに紐づく
  belongs_to :group   #1つのグループに紐づく

  # enum の定義(状態一覧, pending:申請前（デフォルト値）, requested:申請中, approved:許可済み, rejected:拒否)
  enum status: { pending: 0, requested: 1, approved: 2, rejected: 3 }

  # 指定のユーザーが指定のグループに参加申請中（pending または requested）かどうか判定するクラスメソッド
  def self.requesting?(user, group)
    exists?(user_id: user.id, group_id: group.id, status: [:pending, :requested])
  end
end
