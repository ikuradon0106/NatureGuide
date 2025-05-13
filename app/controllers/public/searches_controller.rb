class Public::SearchesController < ApplicationController
  # 該当ユーザーとしてログインしている場合のみアクセス許可
  before_action :authenticate_user!

  def new
  end

  def index
  end

  def show
  end

  def search_feature
    @word = params[:word]
    @model = params[:model]

    # blankメソッドを使用し、モデルが空の場合は、すべてのモデルを検索
    if @model.blank?
      @records = User.search_for(@word)
      @records = Post.search_for(@word)
      @records = Group.search_for(@word)
    elsif @model =="user"
      @records = User.search_for(@word)
    elsif @model =="post"
      @records = Post.search_for(@word)
    elsif @model =="group"
      @records = Group.search_for(@word)
    else
      # 無効な検索の場合の処理（一応）
      flash[:alert] = "無効な検索が行われました。"
      redirect_to search_feature_path
    end
  end
end
