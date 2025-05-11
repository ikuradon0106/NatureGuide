class Public::UsersController < ApplicationController
  # 該当ユーザーとしてログインしている場合のみアクセス許可
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy] 

  # マイページの表示
  def mypage
    @user = current_user
    @user_posts = @user.posts
  end

  # マイプロフィール編集の表示
  def edit
    @user = current_user
  end

  # ユーザー編集処理
  def update
    @user = current_user
    if @user.update(user_params)
      flash[:notice] = "編集に成功しました。"
      redirect_to edit_user_path(@user)
    else
      flash.now[:alert] = "編集に失敗しました。"
      render :edit
    end
  end

  # ユーザー退会確認画面
  def unsubscribe
  end

    # ユーザー退会処理（ステータスの更新）
  def withdraw
    if current_user.update(is_active: false)
      reset_session
      flash[:notice] = "退会手続きが完了しました。ご利用いただきありがとうございました。"
      redirect_to root_path
    else
      flash[:alert] = "退会処理に失敗しました。もう一度お試しください。"
      redirect_to mypage_path
    end
  end

  # ユーザーデータのストロングパラメータ
  private

  def user_params
    params.require(:user).permit(:email, :nickname, :user_image, :introduction)
  end

  # 該当ユーザーでない場合、アクセスを制限するメソッド
  def ensure_correct_user
      unless @user = current_user
        flash[:alert] = "権限がありません"
        redirect_to root_path
      end
  end
end
