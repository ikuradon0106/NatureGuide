class Public::GroupsController < ApplicationController
  # ユーザーがログインしている場合のみ、各アクションを実行する（未ログイン時はリダイレクト）
  before_action :authenticate_user!

  # グループの新規登録画面の表示
  def new
    @group = Group.new
  end

  # ページネーション付きでグループの一覧を取得し、一覧画面を表示する
  def index
    @groups = Group.page(params[:page])
  end

  # グループ詳細表示画面
  def show
    @group = Group.find(params[:id])
    # 現在ログイン中のユーザー（current_user）が、表示中のグループ(@group)に対して、「申請中」ステータスの新しいインスタンスを作成
    @group_request = GroupRequest.new(user: current_user, group: @group, status: GroupRequest.statuses[:requested])
  end

  # グループ新規作成処理
  def create
    @group = Group.new(group_params)
    # 作成者（現在ログイン中のユーザー）をグループのオーナーとして設定
    @group.owner_id = current_user.id

    if @group.save
      # グループのオーナーをメンバーに追加する処理
      # 演算子「<<」は、このグループ（@group）のメンバー一覧（users）に、ログインユーザー(current_user)を追加する（要素を追加するのが演算子）
      @group.users << current_user
      flash[:notice] = "グループを作成しました。"
      # 作成したグループの一覧画面に遷移
      redirect_to groups_path
    else
      flash[:alert] = "グループの作成に失敗しました。もう一度お試しください。"
      # グループの新規登録画面に再表示
      render :new
    end

  end

  # グループ編集画面の表示
  def edit
    @group = Group.find(params[:id])
  end

  # グループ更新処理
  def update
    @group = Group.find(params[:id])

    # 取得した該当のグループの更新処理
    if @group.update(group_params)
      flash[:notice] = "編集に成功しました。"
      # グループ詳細画面へ遷移
      redirect_to group_path(@group)
    else
      flash.now[:alert] = "編集に失敗しました。"
      # グループ詳細画面を再表示
      render :edit
    end

  end

  # グループ削除処理
  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    # グループ一覧画面に遷移
    redirect_to groups_path
  end

  # グループのストロングパラメータ（許可されたパラメータのみを取得）
  private

    def group_params
      params.require(:group).permit(:group_image, :group_name, :description)
    end

end
