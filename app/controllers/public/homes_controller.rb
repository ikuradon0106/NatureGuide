class Public::HomesController < ApplicationController

  def top
    # 投稿を作成日時の降順で3件取得（最新3件にするため）
    @posts = Post.order(created_at: :desc).limit(3)
  end

  def about
  end
  
end
