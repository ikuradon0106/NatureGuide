class Admin::NoticesController < ApplicationController
  # 管理者としてログインしている場合のみアクセス許可
  before_action :authenticate_admin!

  def index
    @notices = Notice.order(created_at: :desc).limit(5) # 最新5件だけ表示
    @notice = Notice.new
  end

  def new
  end

  def create
    @notice = Notice.new(notice_params)

    if @notice.save
      flash[:notice] = "お知らせを作成しました。"
      redirect_to admin_admin_path
    else
      flash.now[:alert] = "作成に失敗しました。入力内容を確認してください。"
      render :index
    end

  end

  def edit
  end

  def update
  end

  def destroy
  end

  # ユーザーデータのストロングパラメータ
  private

  def notice_params
    params.require(:notice).permit(:title, :body, :published)
  end

end
