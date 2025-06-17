class Admin::HomesController < ApplicationController
  # 管理者としてログインしている場合のみアクセス許可
  before_action :authenticate_admin!

  def top
    @notice = Notice.new
    @notices = Notice.order(created_at: :desc).page(params[:page]).per(5) # 5件だけ表示
  end
end
