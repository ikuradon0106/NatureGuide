class Admin::GroupsController < ApplicationController
  # 管理者としてログインしている場合のみアクセス許可
  before_action :authenticate_admin!

  def new
  end

  # グループ一覧の表示
  def index
    @groups = Group.all
  end

  def show
  end

  def create
  end

  def edit
  end

  def update
  end

    # グループ削除処理
  def destroy
    @group = Group.find(params[:id])

    if @group.destroy
      flash[:notice] = "削除に成功しました。"
    else
      flash[:alert] = "削除に失敗しました。"
    end
    redirect_to admin_groups_path
  end

  def add_member
  end

  def remove_member
  end
end
