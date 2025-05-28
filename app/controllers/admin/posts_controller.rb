class Admin::PostsController < ApplicationController
  # 管理者としてログインしている場合のみアクセス許可
  before_action :authenticate_admin!

  # 投稿一覧の表示
  def index
    @posts = Post.all.page(params[:page])
  end

  # 投稿詳細の表示
  def show
    @post = Post.find(params[:id])

    respond_to do |format|
      format.html
      format.json do
        render json: @post.as_json(only: [:id, :title, :body, :latitude, :longitude, :address])
      end
    end
  end

  # 投稿詳編集表示
  def edit
    @post = Post.find(params[:id])
  end

  # 投稿データの更新
  def update
    @post = Post.find(params[:id])

    if @post.update(post_params)
      flash[:notice] = "編集に成功しました。"
      redirect_to admin_post_path(@post)
    else
      flash.now[:alert] = "編集に失敗しました。"
      render :edit
    end
  end

  # 投稿データの削除
  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to admin_posts_path
  end

  # 投稿データのストロングパラメータ
  private
    def post_params
      params.require(:post).permit(:title, :body, :image, :address, :latitude, :longitude)
    end
end
