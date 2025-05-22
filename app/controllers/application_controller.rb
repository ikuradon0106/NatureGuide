# 共通controller
class ApplicationController < ActionController::Base
  # すべてのアクションの前に最後に記述したメソッドを呼び出す
  before_action :set_api_key

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

  def set_api_key
    @maps_api_key = ENV['Maps_API_Key']
  end

end
