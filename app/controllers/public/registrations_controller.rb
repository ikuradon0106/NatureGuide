# ユーザーが新規登録（サインアップ）を行う際のcontroller
class Public::RegistrationsController < Devise::RegistrationsController
  # ユーザー新規登録時に追加のパラメータを許可する処理を呼び出す
  before_action :configure_sign_up_params, only: [:create]

  def create
    # フォームから送られてきた情報で新しいユーザーを作る
    build_resource(sign_up_params)
  
    # ユーザー情報をDBに保存。保存成功ならtrue、失敗ならfalseを返す
    if resource.save
      # 登録ができたというメッセージを表示
      set_flash_message! :notice, :signed_up
      # 新規登録ユーザーとしてログイン状態にする
      sign_up(resource_name, resource)
      # 登録後のリダイレクト先へ遷移
      redirect_to after_sign_up_path_for(resource)
    else
      flash[:alert] = "登録に失敗しました。入力内容をご確認ください。"
      #登録ページを再度表示
      redirect_to new_registration_path(resource_name)
    end

  end  

  private
    # ユーザー登録時にnicknameカラムを許可（デフォルトでは許可されないため）
    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname])
    end
    
end
