class Admin::CommentsController < ApplicationController
  # 管理者としてログインしている場合のみアクセス許可
  before_action :authenticate_admin!

  # コメント一覧画面
  def index
    @comments = Comment.all.page(params[:page])
    @comment = Comment.new
  end

  # コメント一覧
  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      respond_to do |format|
        format.html { redirect_to admin_comments_path, notice: '新規コメント追加に成功しました。' }
        format.js   # create.js.erb を実行
      end
    else
      # errors[]→特定の属性についてエラーメッセージをチェックしたい場合に使う
      respond_to do |format|
        format.html do
          flash.now[:alert] = @comment.errors[:body].present? ? "空欄にはできません。" : "新規コメント追加に失敗しました。"
          redirect_to admin_comments_path
        end
        format.js   # create.js.erb を実行しエラーメッセージを表示
      end
    end
  end

  # コメント編集画面
  def edit
    @comment = Comment.find(params[:id])
  end

  def update
    @comment = Comment.find(params[:id])
    
    if @comment.update(comment_params)
      flash[:notice] = "編集に成功しました。"
      redirect_to admin_comments_path
    else
      flash.now[:alert] = "編集に失敗しました。"
      render :edit
    end
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
