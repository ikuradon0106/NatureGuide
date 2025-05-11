class Admin::UsersController < ApplicationController
  # 管理者としてログインしている場合のみアクセス許可
  before_action :authenticate_admin!

  def index
  end

  def show
  end

  def edit
  end

  def update
  end
end
