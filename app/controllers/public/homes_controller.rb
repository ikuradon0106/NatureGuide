class Public::HomesController < ApplicationController
  def top
    # 投稿を作成日時の降順で9件取得（最新9件にするため）
    @posts = Post.order(created_at: :desc).limit(9)
  end

  def about
  end
end
