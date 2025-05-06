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
    
    # users_controller
    get 'users/mypage', to: "users#mypage", as: 'mypage'
    resources :users, only: [:edit, :show, :update]
    get 'users/unsubscribe', to: "users#unsubscribe"
    get 'users/withdraw', to: "users#withdraw"

    # posts_controller
    resources :posts, only: [:new, :index, :show, :create, :edit, :update, :destroy] do
      # comments_controller（ネストさせる）
        resources :comments, only: [:new, :create, :edit, :update, :destroy]
      end

    # groups_controller
    resources :groups, only: [:new, :index, :show, :create, :edit, :update, :destroy]
    
  end

  # 管理者側のrouting設定
  namespace :admin do
    get 'homes/top', to: "homes#top", as: ''

    # users_controller
    resources :users, only: [:index, :show, :edit, :update] do
      # searches_controller(ネストさせる)
        resources :searches, only: [:index, :show, :destroy]
        get 'searches/destroy_all', to: "searches#destroy_all"
      end
    
    # posts_controller
    resources :posts, only: [:index, :new, :create, :show, :edit, :update, :destroy]

    # comments_controller
    resources :comments, only: [:index, :create, :edit, :update, :destroy]

    # groups_controller
    resources :groups, only: [:new, :index, :show, :create, :edit, :update, :destroy] do
      get 'groups/add_member',  to: "groups#add_member"
      get 'groups/remove_member',  to: "groups#remove_member"
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
