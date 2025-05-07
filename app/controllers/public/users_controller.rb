class Public::UsersController < ApplicationController
  # 該当ユーザーとしてログインしている場合のみアクセス許可
  before_action :authenticate_user!

  def mypage
  end

  def edit
  end

  def show
  end

  def update
  end

  def unsubscribe
  end

  def withdraw
  end
end
