class Public::PostsController < ApplicationController
  # 該当ユーザーとしてログインしている場合のみアクセス許可
  before_action :authenticate_user!

  # 新規投稿の表示
  def new
    @post = Post.new
  end

  # 投稿一覧の表示
  def index
  end

  # 投稿詳細の表示
  def show
  end

  # 投稿データの保存
  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    @post.save
    redirect_to new_post_path
  end

  # 投稿の編集画面
  def edit
  end

  # 投稿の更新処理
  def update
  end

  # 投稿の削除処理
  def destroy
  end

  # 投稿データのストロングパラメータ
  private

  def post_params
    params.require(:post).permit(:title, :body, :latitude, :longitude, :image)
  end
end
