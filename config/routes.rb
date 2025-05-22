Rails.application.routes.draw do

  # ユーザー側
  # controllerがどこに存在するか記述(skipオプションで不要なroutingの削除)
  devise_for :users, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }

  # 管理者側
  # controllerがどこに存在するか記述(skipオプションで不要なroutingの削除)
  devise_for :admins, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }

  # ユーザー側のルーティング(controllerやviewのパスだけを変更)
  scope module: :public do
    root to: "homes#top"
    get 'about', to: "homes#about", as: 'about'
    
    # users関連
    get 'users/mypage',             to: "users#mypage",      as: 'mypage'
    get 'users/mypage/edit',        to: "users#edit"
    patch 'users/mypage/update',    to: "users#update"
    get 'users/unsubscribe',        to: "users#unsubscribe"
    patch 'users/withdraw',         to: "users#withdraw"
    resources :users, only: [:show]

    # posts関連
    resources :posts do
        # comments関連（ネストさせる）
        resources :comments, only: [:new, :index, :create, :edit, :update, :destroy]
      end

    # groups関連
    resources :groups do
      # group_requests関連(ネストさせる)
      resources :group_requests, only: [:create, :update, :destroy]
    end

    # searches関連
    resources :searches, only: [:new, :index, :show]
    get '/search_feature', to: "searches#search_feature", as: 'search_feature'
    get 'searches/fetch_image', to: 'public/searches#fetch_image'
    
  end

  # 管理者側のルーティング（routingやcontroller、viewのパスも変更）
  namespace :admin do
    get 'homes/top', to: "homes#top", as: 'admin'

    # users関連
    resources :users, only: [:index, :show, :edit, :update] do
      # searches関連(ネストさせる)
        resources :searches, only: [:index, :show, :destroy]
        get 'searches/destroy_all', to: "searches#destroy_all"
      end
    
    # posts関連
    resources :posts

    # comments関連
    resources :comments, only: [:index, :create, :edit, :update, :destroy]

    # groups関連
    resources :groups do
      get 'groups/add_member',  to: "groups#add_member"
      get 'groups/remove_member',  to: "groups#remove_member"
    end
  end
end
