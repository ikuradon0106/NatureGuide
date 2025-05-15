class Admin::UsersController < ApplicationController
  # 管理者としてログインしている場合のみアクセス許可
  before_action :authenticate_admin!

  # 全ユーザー一覧画面の表示
  def index
    @users = User.all
  end

  # 各ユーザー詳細画面の表示
  def show
    @user = User.find(params[:id])
  end

  def edit
  end

  def update
  end


end
