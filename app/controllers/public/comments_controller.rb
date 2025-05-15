class Public::CommentsController < ApplicationController
  # 該当ユーザーとしてログインしている場合のみアクセス許可
  before_action :authenticate_user!

  # コメント一覧画面
  def index
    @post = Post.find(params[:post_id])
    @comments = @post.comments
  end

  # コメント投稿処理
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.new(comment_params)
    @comment.user = current_user
    
    if @comment.save
      flash[:notice] = "投稿に成功しました。"
      redirect_to post_comments_path(@post)
    else
      # errors[]→特定の属性についてエラーメッセージをチェックしたい場合に使う
      if @comment.errors[:body].present?
        flash.now[:alert] = "投稿に失敗しました。空欄にはできません。"
      else
        flash.now[:alert] = "投稿に失敗しました。"
      end
      render 'public/posts/show'
    end
  end

  # コメント編集機能
  def edit
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
  end

  # コメント編集処理
  def update
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])

    # 不正ユーザーによるアクセスは拒否してリダイレクト（unless文）
    unless @comment.user == current_user
      flash[:alert] = "自分のコメント以外は編集できません。"
      redirect_to request.referrer
    else
      # コメント更新処理
      if @comment.update(comment_params)
        flash[:notice] = "編集に成功しました。"
        redirect_to  post_comments_path(@post)
      else
        flash.now[:alert] = "編集に失敗しました。空欄にはできません。"
        render :edit
      end
    end
  end

  # コメント削除処理
  def destroy
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])

    if @comment.user == current_user 
      @comment.destroy
      flash[:notice] = "削除に成功しました。"
    else
      flash[:alert] = "自分のコメント以外は削除できません。"
    end

    redirect_to  post_comments_path(@post)
  end

  # コメントのストロングパラメータ
  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
