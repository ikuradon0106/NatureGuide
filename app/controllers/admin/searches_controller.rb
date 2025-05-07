class Admin::SearchesController < ApplicationController
  # 管理者としてログインしている場合のみアクセス許可
  before_action :authenticate_admin!

  def index
  end

  def show
  end

  def destroy
  end

  def destroy_all
  end
end
