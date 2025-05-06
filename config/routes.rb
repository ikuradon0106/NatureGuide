Rails.application.routes.draw do
  devise_for :group_users
  devise_for :groups
  devise_for :searches
  devise_for :comments
  devise_for :categories
  devise_for :posts
  devise_for :admins
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
