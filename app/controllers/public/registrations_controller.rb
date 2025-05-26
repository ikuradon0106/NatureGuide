# ユーザーが新規登録（サインアップ）を行う際のcontroller
class Public::RegistrationsController < Devise::RegistrationsController
  # ユーザー新規登録時に追加のパラメータを許可する処理を呼び出す
  before_action :configure_sign_up_params, only: [:create]

  private

  # ユーザー登録時にnicknameカラムを許可（デフォルトでは許可されないため）
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname])
  end
end
