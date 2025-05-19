class Public::GroupsController < ApplicationController
  # 該当ユーザーとしてログインしている場合のみアクセス許可
  before_action :authenticate_user!

  # グループの新規登録画面
  def new
    @group = Group.new
  end

  # グループ一覧表示画面
  def index
    @groups = Group.all
  end

  # グループ詳細表示画面
  def show
    @group = Group.find(params[:id])
    @group_request = GroupRequest.new(user: current_user, group: @group, status: "requested")
  end

  # グループ新規作成処理
  def create
    @group = Group.new(group_params)
    @group.owner_id = current_user.id
    if @group.save
      # オーナーをメンバーに追加する処理(演算子<< は「配列やコレクションに要素を追加する操作」)
      @group.users << current_user
      flash[:notice] = "グループを作成しました。"
      redirect_to groups_path(@group)
    else
      flash[:alert] = "グループの作成に失敗しました。もう一度お試しください。"
      render :new
    end
  end

  # グループ編集画面表示
  def edit
    @group = Group.find(params[:id])
  end

  # グループ更新処理
  def update
    @group = Group.find(params[:id])
    
    if @group.update(group_params)
      flash[:notice] = "編集に成功しました。"
      redirect_to group_path(@group)
    else
      flash.now[:alert] = "編集に失敗しました。"
      render :edit
    end
  end

  # グループ削除処理
  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    redirect_to groups_path
  end

  # ストロングパラメータ
  private

  def group_params
    params.require(:group).permit(:group_image, :group_name, :description)
  end
end
