# 共通controller
class ApplicationController < ActionController::Base
  # ログイン時以外は認証を適用（トップページとアバウトページを除く）
  before_action :authenticate_user!, except: [:top, :about]

  # ログイン後にマイページに転移
  def after_sign_in_path_for(resource)
    mypage_path
  end

   # 新規登録後にログインページに転移
   def after_sign_up_path_for(resource)
    new_user_session_path 
  end

  # ログアウト後にマイページに転移
  def after_sign_out_path_for(resource)
    root_path
  end

  # 他のコントローラでも使えるように protected を設定
  protected

end
