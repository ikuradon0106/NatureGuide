# 共通controller
class ApplicationController < ActionController::Base
  # Devise使用時に、事前にストロングパラメータ（configure_permitted_parametersメソッド）を設定
  before_action :configure_permitted_parameters, if: :devise_controller?

  # sign in後にマイページに転移
  def after_sign_in_path_for(resource)
    mypage_path
  end

  # sign out後にマイページに転移
  def after_sign_out_path_for(resource)
    root_path
  end

  # 他のコントローラからも参照するために
  protected

  # ユーザー登録時にnicknameカラム（データ操作）を許可する（デフォルトでは許可されないため）
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname])
  end
end
