class Public::UsersController < ApplicationController
  # ユーザーがログインしている場合のみ、各アクションを実行する（未ログイン時はリダイレクト）
  before_action :authenticate_user!

  # マイページの表示
  def mypage
    @user = current_user
    # 自分の投稿をページネーション付きで取得
    @user_posts = @user.posts.page(params[:page])
  end

  # ユーザー詳細画面の表示
  def show
    @user = User.find(params[:id])
  end

  # マイプロフィール編集の表示
  def edit
    @user = current_user
  end

  # ユーザー更新処理
  def update
    @user = current_user

    if @user.update(user_params)
      flash[:notice] = "ユーザーの編集に成功しました。"
      # マイページに遷移
      redirect_to mypage_path(@user)
    else
      flash[:alert] = "ユーザーの編集に失敗しました。"
      # ユーザー編集画面を再度表示
      redirect_to users_mypage_edit_path(@user)
    end
  end

  # ユーザー退会確認画面
  def unsubscribe
  end

  # ユーザー退会処理（ステータスの更新）
  def withdraw
    if current_user.update(is_active: false)
      flash[:notice] = "退会手続きが完了しました。ご利用いただきありがとうございました。"
      # セッション情報をすべて削除
      reset_session
      # Topページに遷移
      redirect_to root_path
    else
      flash[:alert] = "退会処理に失敗しました。もう一度お試しください。"
      # マイページに遷移
      redirect_to mypage_path
    end
  end


  private
    # ユーザーのストロングパラメータ（許可されたパラメータのみを取得）
    def user_params
      params.require(:user).permit(:email, :nickname, :user_image, :introduction)
    end
end
