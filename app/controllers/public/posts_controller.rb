class Public::PostsController < ApplicationController
  # 該当ユーザーとしてログインしている場合のみアクセス許可
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy] 

  # 新規投稿の表示
  def new
    @post = Post.new
  end

  # 投稿一覧の表示
  def index
    @posts = Post.all
  end

  # 投稿詳細の表示
  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
  end

  # 投稿データの保存
  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      flash[:notice] = "投稿に成功しました。"
      redirect_to post_path(@post)
    else
      flash.now[:alert] = "投稿に失敗しました。"
      render :new
    end
  end

  # 投稿の編集画面
  def edit
    @post = Post.find(params[:id])
  end

  # 投稿の更新処理
  def update
    @post = Post.find(params[:id])
    
    if @post.update(post_params)
      flash[:notice] = "編集に成功しました。"
      redirect_to post_path(@post)
    else
      flash.now[:alert] = "編集に失敗しました。"
      render :edit
    end
  end

  # 投稿の削除処理
  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_path
  end

  # 投稿データのストロングパラメータ
  private

  def post_params
    params.require(:post).permit(:title, :body, :latitude, :longitude, :location_name, :image)
  end

  # 投稿者でない場合、アクセスを制限するメソッド
  def ensure_correct_user
    @post = Post.find(params[:id])
    unless @post.user == current_user
      flash[:alert] = "権限がありません"
      redirect_to posts_path
    end
  end
end
