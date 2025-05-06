Rails.application.routes.draw do
  # ユーザー側
  # URL /users/sign_in ...
  # controllerがどこに存在するか記述(skipオプションで不要なroutingの削除)
  devise_for :users, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }

  # 管理者側
  # URL /admin/sign_in ...
  # controllerがどこに存在するか記述(skipオプションで不要なroutingの削除)
  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }

  # ユーザー側のrouting設定(controllerやviewのパスだけを変更)
  scope module: :public do
    root to: "homes#top"
    get 'about', to: "homes#about", as: 'about'
  end
    

  # 会員側のrouting設定



  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
