class Public::HomesController < ApplicationController

  # トップページ
  def top
    # 投稿を作成日時の降順で9件取得（最新9件にするため）
    @posts = Post.order(created_at: :desc).limit(9)
  end

  # アバウトページ
  def about
  end

end
