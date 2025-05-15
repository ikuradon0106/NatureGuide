# 共通controller
class ApplicationController < ActionController::Base

  # ログイン後に各マイページに転移(会員側と管理者側で変化)
  def after_sign_in_path_for(resource)
    case resource
    when Admin
      admin_admin_path
    when User
      mypage_path
    else
      root_path
    end
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
