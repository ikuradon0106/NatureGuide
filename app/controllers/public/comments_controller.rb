class Public::CommentsController < ApplicationController
  # ユーザーがログインしている場合のみ、各アクションを実行する（未ログイン時はリダイレクト）
  before_action :authenticate_user!

  # コメント一覧画面の表示（指定された投稿に紐づくコメントをページネーション付きで取得）
  def index
    @post = Post.find(params[:post_id])
    @comments = @post.comments.page(params[:page]).per(10)
  end

  # コメント新規投稿処理
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.new(comment_params)
    # コメントの所有者を現在のユーザーに指定
    @comment.user = current_user

    if @comment.save
      flash[:notice] = "投稿に成功しました。"
      # コメント一覧がある投稿詳細画面へ遷移
      redirect_to post_path(@post)
    else
      # errors[]→特定の属性についてエラーメッセージをチェックしたい場合に使用（バリテーションエラーで、空欄をユーザーに提示）
      if @comment.errors[:body].present?
        flash.now[:alert] = "投稿に失敗しました。投稿は空欄にはできません。"
      else
        flash.now[:alert] = "投稿に失敗しました。"
      end
      # 投稿詳細画面へ再度表示
      render "public/posts/show"
    end

  end

  # コメント編集画面の表示
  def edit
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
  end

  # コメント更新処理
  def update
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])

    # 不正ユーザーによるアクセスは拒否して同じ画面にリダイレクト（unless文）
    unless @comment.user == current_user
      flash[:alert] = "自分のコメント以外は編集できません。"
      # 直接URL入力時にrequest.referrerがnilの場合に備え、root_pathへのリダイレクトも考慮
      redirect_to request.referrer || root_path
    else
      # コメント更新処理
      if @comment.update(comment_params)
        flash[:notice] = "編集に成功しました。"
        # コメント一覧がある投稿詳細画面へ遷移
        redirect_to post_path(@post)
      else
        # バリテーションエラーで、空欄をユーザーに提示
        flash.now[:alert] = "編集に失敗しました。コメントは空欄にはできません。"
        # 投稿編集画面へ再度表示
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
      flash[:notice] = "コメントの削除に成功しました。"
    else
      # 不正削除を防止
      flash[:alert] = "自分のコメント以外は削除できません。"
    end

    # コメント一覧がある投稿詳細画面へ遷移
    redirect_to post_path(@post)
  end

  # コメントのストロングパラメータ（許可されたパラメータのみを取得）
  private
  
    def comment_params
      params.require(:comment).permit(:body)
    end

end
