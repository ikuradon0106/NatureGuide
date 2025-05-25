class Admin::UsersController < ApplicationController
  # 管理者としてログインしている場合のみアクセス許可
  before_action :authenticate_admin!

  # 全ユーザー一覧画面の表示
  def index
    @users = User.all.page(params[:page])
  end

  # 各ユーザー詳細画面の表示
  def show
    @user = User.find(params[:id])
  end

  # 編集画面の表示
  def edit
    @user = User.find(params[:id])
  end

  # 編集更新処理
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "編集に成功しました。"
      redirect_to admin_user_path(@user)
    else
      flash.now[:alert] = "編集に失敗しました。"
      render :edit
    end
  end

  # ユーザーデータのストロングパラメータ
  private
    def user_params
      params.require(:user).permit(:email, :nickname, :user_image, :introduction, :is_active)
    end
end
