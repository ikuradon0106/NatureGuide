class Public::GroupRequestsController < ApplicationController
  # 該当ユーザーとしてログインしている場合のみアクセス許可
  before_action :authenticate_user!

  # グループ申請処理
  def create
    @group = Group.find(params[:group_id])

    # 申請データを生成（どのグループに誰が申請するかを指定）
    # この記述で、group_id = @group.id, user_id = current_user.id とRailsが内部で自動的に変換
    @group_request = GroupRequest.new(
      group: @group,
      user: current_user
    )

    if @group_request.save
      flash[:notice] = "グループへの参加申請を送信しました"
    else
      flash[:alert] = "申請に失敗しました"
    end
    redirect_to group_path(@group)
  end

  # グループ申請の承認・拒否処理
  def update
    @group_request = GroupRequest.find(params[:id])
    @group = @group_request.group

    if current_user.id == @group.owner_id
      if params[:decision] == "approve"
        @group_request.update(status: "approved")
        flash[:notice] = "#{@group_request.user.nickname}さんの申請を承認しました"
      elsif params[:decision] == "reject"
        @group_request.update(status: "rejected")
        flash[:alert] = "#{@group_request.user.nickname}さんの申請を拒否しました"
      else
        flash[:alert] = "不正な操作です"
      end
    else
      flash[:alert] = "権限がありません"
    end
    redirect_to group_path(@group)
  end

  # 申請したユーザーのグループ申請を削除処理
  def destroy
    @group_request = GroupRequest.find(params[:id])
    @group = @group_request.group

    # 申請者本人かどうかチェックし、削除
    if @group_request.user_id == current_user.id
      @group_request.destroy
      flash[:notice] = "参加申請をキャンセルしました"
    else
      flash[:alert] = "権限がありません"
    end
    redirect_to group_path(@group)
  end
end
