class Admin::HomesController < ApplicationController
  # 管理者としてログインしている場合のみアクセス許可
  before_action :authenticate_admin!

  def top
    @notice = Notice.new
  end
end
