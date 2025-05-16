class Admin::CommentsController < ApplicationController
  # 管理者としてログインしている場合のみアクセス許可
  before_action :authenticate_admin!

  def index
    @comments = Comment.all
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
