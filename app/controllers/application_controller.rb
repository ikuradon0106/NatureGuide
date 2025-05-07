# 共通controller
class ApplicationController < ActionController::Base
  # ログイン時以外は認証を適用（トップページとアバウトページを除く）
  before_action :authenticate_user!, except: [:top, :about]

  # sign in後にマイページに転移
  def after_sign_in_path_for(resource)
    mypage_path
  end

  # sign out後にマイページに転移
  def after_sign_out_path_for(resource)
    root_path
  end

  # 他のコントローラでも使えるように protected を設定
  protected

end
