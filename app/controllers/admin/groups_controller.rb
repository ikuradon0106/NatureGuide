class Admin::GroupsController < ApplicationController
  # 管理者としてログインしている場合のみアクセス許可
  before_action :authenticate_admin!

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

  def add_member
  end

  def remove_member
  end
end
