class Admin::CommentsController < ApplicationController
  # 管理者としてログインしている場合のみアクセス許可
  before_action :authenticate_admin!

  # コメント一覧画面
  def index
    @comments = Comment.all
    @comment = Comment.new
  end

  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      flash[:notice] = "投稿に成功しました。"
    else
        # errors[]→特定の属性についてエラーメッセージをチェックしたい場合に使う
        if @comment.errors[:body].present?
          flash.now[:alert] = "投稿に失敗しました。空欄にはできません。"
        else
          flash.now[:alert] = "投稿に失敗しました。"
        end
      redirect_to admin_comments_path
    end
  end

  def edit
  end

  def update
  end

  # コメント削除画面
  def destroy
    @comment = Comment.find(params[:id])

    if @comment.destroy
      flash[:notice] = "削除に成功しました。"
    else
      flash[:alert] = "削除に失敗しました。"
    end
    redirect_to admin_comments_path
  end

  # コメントのストロングパラメータ
  private

  def comment_params
    params.require(:comment).permit(:user_id, :post_id, :body)
  end
end
