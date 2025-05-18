class Public::GroupRequestsController < ApplicationController
  # 該当ユーザーとしてログインしている場合のみアクセス許可
  before_action :authenticate_user!

  # グループ申請処理
  def create
    @group = Group.new(params[:group_id])
    @group.user_id = current_user.id
      if @group.save
        flash[:notice] = "グループへの参加申請を送信しました"
        redirect_to post_path(@post)
      else
        flash.now[:alert] = "投稿に失敗しました。"
        render :new
      end

  end

  # グループ申請の承認・拒否処理
  def update
  end

  # グループ申請を削除処理
  def destroy
  end
end
