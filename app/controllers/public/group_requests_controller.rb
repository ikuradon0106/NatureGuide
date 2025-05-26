class Public::GroupRequestsController < ApplicationController
  # ユーザーがログインしている場合のみ、各アクションを実行する（未ログイン時はリダイレクト）
  before_action :authenticate_user!

  # グループ参加申請処理
  def create
    @group = Group.find(params[:group_id])

    # 申請データを生成（どのグループに誰が申請するかを指定）
    # group_id = @group.id, user_id = current_user.id とRailsが内部で自動的に変換する
    @group_request = GroupRequest.new(
      group: @group,
      user: current_user
    )

    if @group_request.save
      flash[:notice] = "グループへの参加申請を送信しました"
    else
      flash[:alert] = "グループへの参加申請に失敗しました"
    end

    redirect_to group_path(@group)
  end

  # グループ参加申請の承認・拒否処理
  def update
    @group_request = GroupRequest.find(params[:id])
    @group = @group_request.group

    # グループのオーナーの承認・拒否
    if current_user.id == @group.owner_id

      # ハッシュを使用して、処理速度を早くする
        decisions = {
        "承認" => { status: "approved", flash_key: :notice, message: "#{@group_request.user.nickname}さんの申請を承認しました" },
        "拒否"  => { status: "rejected", flash_key: :alert, message: "#{@group_request.user.nickname}さんの申請を拒否しました" }
      }

      # params[:decision] に対応する処理をハッシュから取得
      decision = decisions[params[:decision]]

      
      if decision
        # 該当する場合はステータス更新とフラッシュメッセージを設定
        @group_request.update(status: decision[:status])
        flash[decision[:flash_key]] = decision[:message]
      else
        # params[:decision]が期待した値でなければエラーメッセージを表示
        flash[:alert] = "不正な操作です"
      end

    else
      # グループオーナー以外が承認・拒否しようとした場合
      flash[:alert] = "権限がありません"
    end

    redirect_to group_path(@group)
  end

  # 申請済ユーザーのグループ申請を削除する処理
  def destroy
    @group_request = GroupRequest.find(params[:id])
    @group = @group_request.group

    # 申請者本人かどうかチェックし、グループ申請を削除
    if @group_request.user_id == current_user.id
      @group_request.destroy
      flash[:notice] = "参加申請をキャンセルしました"
    else
      flash[:alert] = "権限がありません"
    end

    redirect_to group_path(@group)
  end

end
