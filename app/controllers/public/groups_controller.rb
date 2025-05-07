class Public::GroupsController < ApplicationController
  # 該当ユーザーとしてログインしている場合のみアクセス許可
  before_action :authenticate_user!

  def new
  end

  def index
  end

  def show
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
