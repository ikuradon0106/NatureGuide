class Public::SearchesController < ApplicationController
  # 該当ユーザーとしてログインしている場合のみアクセス許可
  before_action :authenticate_user!

  def new
  end

  # APIの結果を@responseに代入し、ビューで表示
  def index
    if params[:keyword].present?
      @response = Gbif::Species.name_usage(name: params[:keyword])

      # ページ番号と1ページあたり件数
      page = params[:page] || 1
      per_page = 5

      # 配列にページネーションを適用
      paginated_results = Kaminari.paginate_array(@response["results"]).page(page).per(per_page)

      @results = paginated_results

      # 各種の taxonKey に対応する画像URLを取得
      @image_urls = {}
      @results.each do |species|
        key = species["key"]
        next unless key.present?
        @image_urls[key] = fetch_image_url(key)
      end
    else
      @response = nil
      @results = []
      @image_urls = {}
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  # Rails.cache でキャッシュ（サーバー側に一時保存）
  # 概要：一度取得した画像URLを一定時間サーバーに保持し、再リクエスト時にAPIを叩かない。
  def fetch_image_url(taxon_key)
    Rails.cache.fetch("gbif_image_#{taxon_key}", expires_in: 12.hours) do
    response = Faraday.get("https://api.gbif.org/v1/occurrence/search", {
      taxonKey: taxon_key,
      mediaType: "StillImage",
      limit: 1
    })

    image_data = JSON.parse(response.body)
    image_data["results"].dig(0, "media", 0, "identifier")
  end
  end

  def fetch_image
    taxon_key = params[:taxon_key]
    image_url = fetch_image_url(taxon_key)

    render json: { image_url: image_url }
  end

  def search_feature
    @word = params[:word]
    @model = params[:model]

    # blankメソッドを使用し、モデルが空の場合は、すべてのモデルを検索
    if @model.blank?
      @users = User.search_for(@word)
      @posts = Post.search_for(@word)
      @groups = Group.search_for(@word)
    elsif @model == "user"
      @users = User.search_for(@word)
    elsif @model == "post"
      @posts = Post.search_for(@word)
    elsif @model == "group"
      @groups = Group.search_for(@word)
    else
      # 無効な検索の場合の処理（一応）
      flash[:alert] = "無効な検索が行われました。"
      redirect_to search_feature_path
    end
  end
end
