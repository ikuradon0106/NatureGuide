class Admin::GroupsController < ApplicationController
  # 管理者としてログインしている場合のみアクセス許可
  before_action :authenticate_admin!

  # グループ新規登録の表示
  def new
    @group = Group.new
  end

  # グループ一覧の表示
  def index
    @groups = Group.all.page(params[:page])
  end

  # グループ詳細画面の表示
  def show
    @group = Group.find(params[:id])
  end

  # グループ作成処理
  def create
    @group = Group.new(group_params)

    if @group.save
      flash[:notice] = "グループを作成しました。"
      redirect_to admin_group_path(@group)
    else
      flash.now[:alert] = "作成に失敗しました。"
      render :new
    end
  end

  # グループ編集画面
  def edit
    @group = Group.find(params[:id])
  end

  # グループ更新画面
  def update
    if @group.update(group_params)
      flash[:notice] = "グループを更新しました。"
      redirect_to admin_group_path(@group)
    else
      flash.now[:alert] = "更新に失敗しました。"
      render :edit
    end
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

  private
    def group_params
      params.require(:group).permit(:group_name, :description, :group_image)
    end
end
