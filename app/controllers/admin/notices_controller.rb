class Admin::NoticesController < ApplicationController
  # 管理者としてログインしている場合のみアクセス許可
  before_action :authenticate_admin!

  def create
    @notice = Notice.new(notice_params)
    @notice.published_at = Time.current if @notice.published && @notice.published_at.blank?

    if @notice.save
      flash[:notice] = "お知らせを作成しました。"
      redirect_to admin_admin_path
    else
      flash.now[:alert] = "作成に失敗しました。入力内容を確認してください。"
      render :index
    end

  end

  def edit
    @notice = Notice.find(params[:id])
  end

  def update
    @notice = Notice.find(params[:id])
    # 公開にチェックが入っていて、published_atが空なら現在時刻を設定
    # published_atは将来的に投稿予約のため残す
    if notice_params[:published] == "true" && @notice.published_at.blank?
      @notice.published_at = Time.current
    end

      if @notice.update(notice_params)
        flash[:notice] = "お知らせを更新しました。"
        redirect_to admin_admin_path
      else
        flash.now[:alert] = "更新に失敗しました。入力内容を確認してください。"
        render :edit
      end
  end

  def destroy
    @notice = Notice.find(params[:id])
    if @notice.destroy
      flash[:notice] = "お知らせを削除しました。"
    else
      flash[:alert] = "削除に失敗しました。"
    end
    redirect_to request.referer || admin_admin_path
  end

  # ユーザーデータのストロングパラメータ
  private

  def notice_params
    params.require(:notice).permit(:title, :body, :published, :published_at)
  end

end
