class Public::SearchesController < ApplicationController
  # 該当ユーザーとしてログインしている場合のみアクセス許可
  before_action :authenticate_user!

  def new
  end

    # APIの結果を@responseに代入し、ビューで表示
  def index
    if params[:keyword].present?
      @response = Gbif::Species.name_usage(name: params[:keyword])
      Rails.logger.info "API result first item: #{@response['results'].first.inspect}"
  
      @image_urls = {}
  
      # 種の情報が取得できていれば、画像も取得
      if @response['results'].present?
        # 最初の5件だけ処理する(あとで非同期化or画像データのキャッシュを行う)
        @response['results'].first(5).each do |species|
          taxon_key = species['key']
          next unless taxon_key
  
          # 画像API呼び出し
          image_response = Faraday.get("https://api.gbif.org/v1/occurrence/search", {
            taxonKey: taxon_key,
            mediaType: "StillImage",
            limit: 1
          })
  
          # 画像URLをインスタンス変数に格納（ビューで使用可能に）
          image_data = JSON.parse(image_response.body)
          image_url = image_data["results"].dig(0, "media", 0, "identifier")
          @image_urls[taxon_key] = image_url if image_url.present?
        end
      end
    else
      @response = nil
      @image_urls = {}
    end
  end

  def show
  end

  def search_feature
    @word = params[:word]
    @model = params[:model]

    # blankメソッドを使用し、モデルが空の場合は、すべてのモデルを検索
    if @model.blank?
      @users = User.search_for(@word)
      @posts = Post.search_for(@word)
      @groups = Group.search_for(@word)
    elsif @model =="user"
      @users = User.search_for(@word)
    elsif @model =="post"
      @posts = Post.search_for(@word)
    elsif @model =="group"
      @groups = Group.search_for(@word)
    else
      # 無効な検索の場合の処理（一応）
      flash[:alert] = "無効な検索が行われました。"
      redirect_to search_feature_path
    end
  end
end
