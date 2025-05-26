class Public::SearchesController < ApplicationController
  # ユーザーがログインしている場合のみ、各アクションを実行する（未ログイン時はリダイレクト）
  before_action :authenticate_user!

  def new
  end

  # API（GBIF）の結果を@responseに代入し、ビューで表示(検索処理＋結果一覧表示)
  def index

    # 入力したキーワードがAPI（GBIF）上に存在するか確認
    if params[:keyword].present?
      # キーワードが存在する場合、execute_searchメソッド(private以下に記載)で検索処理を実行
      execute_search(params[:keyword])
    else
      # キーワードが存在しない場合、reset_search_resultsメソッド(private以降に記載)で検索結果を初期化
      reset_search_results
    end

    respond_to do |format|
      format.html
      format.js
    end

  end

  # キャッシュ（リクエスト時にデータを保存しておき、次回の同じリクエストの発生時に、保存しておいたデータを再利用すること）
  # 一度取得した画像URLを一定時間サーバーに保持し、再リクエスト時にAPIを叩かない。（パフォーマンスの高速化に繋げる）
  def get_species_image_url(taxon_key)

    # 「Rails.cache.fetch("キャッシュのキー", expires_in: キャッシュの有効時間) do」 で、引数で指定したキーに対応するキャッシュを返す/無ければ生成して返す
    # 同じ分類群（taxonKey）に対して12時間以内であれば、もう一度APIを呼び出さずにキャッシュから画像URLをすぐに取り出す
    Rails.cache.fetch("gbif_image_#{taxon_key}", expires_in: 12.hours) do
    # HTTPクライアントライブラリのFaradayを使い、指定のURL（GBIFのAPI）に対して、
    # taxonKey（分類群のID）、mediaType（静止画像＝StillImage）、limit（最大1件）をパラメータとして渡し、画像情報を取得するリクエストを送信する（taxonKeyに該当する静止画像を1件だけ取得する）
    response = Faraday.get("https://api.gbif.org/v1/occurrence/search", {
      taxonKey: taxon_key,
      mediaType: "StillImage",
      limit: 1
    })

    # Faraday.get でAPIから取得したレスポンスの本文(body)部分だけを「JSON.parse」でその文字列をRubyが扱いやすいように変換
    image_data = JSON.parse(response.body)
    # digメソッドを使用し、複雑なデータ構造になっている階層の値を取り出す
    # 検索結果を変換したデータ（image_data）から0番目にアクセス→　"media"（画像）の0番目にアクセス→　"identifier"（画像のURLが入っている場所）にある値を取り出す
    image_data["results"].dig(0, "media", 0, "identifier")
    end

  end

  def fetch_image
    taxon_key = params[:taxon_key]
    image_url = get_species_image_url(taxon_key)

    render json: { image_url: image_url }
  end

  # サイト内の検索メソッド
  def search_feature
    # 検索キーワード([:word])と検索対象のモデル名（[:model]）を代入
    @word = params[:word]
    @model = params[:model]

    # blankメソッドを使用し、モデルが空（指定なし）の場合は、すべてのモデルを検索
    if @model.blank?
      # ユーザー、投稿、グループの3つのモデルそれぞれで検索を行い、結果をインスタンス変数に格納
      @users = User.search_for(@word)
      @posts = Post.search_for(@word)
      @groups = Group.search_for(@word)
    elsif @model == "user"
       # @modelに"user"が指定されている場合はユーザーモデルのみ検索
      @users = User.search_for(@word)
    elsif @model == "post"
      # @modelに"post"が指定されている場合は投稿モデルのみ検索
      @posts = Post.search_for(@word)
    elsif @model == "group"
      # @modelに"group"が指定されている場合はグループモデルのみ検索
      @groups = Group.search_for(@word)
    else
      # 無効な検索の場合の処理（一応）
      flash[:alert] = "無効な検索が行われました。"
      # 検索画面に遷移
      redirect_to search_feature_path
    end
    
  end

  private

  # API（GBIF）から検索処理を実行
  def execute_search(keyword)
    # API（GBIF）を使用して、指定された学名（keyword）に一致する種や分類群の詳細情報を取得し、@responseに代入する。
    # Gbif::Species.name_usage は複数候補を含む可能性がある検索結果を返す（公式メソッド）。
    @response = Gbif::Species.name_usage(name: keyword)
    # URLのクエリパラメーター（例: /search?page=2、?より後ろのこと）にページ指定がある場合はその値を使用し、指定がなければ1ページ目を表示（初期表示時など）
    page = params[:page] || 1
    # 1ページあたり5件表示に設定（表示負荷を考慮）
    per_page = 5
    # APIから取得した結果配列（@response["results"]）にページネーションを適用
    # Kaminariのpaginate_arrayは、普通の配列をページネーション可能な形に変換するメソッド
    # これにより、指定ページ（page）と1ページあたりの表示件数（per_page）で結果を分割して表示可能にする
    @results = Kaminari.paginate_array(@response["results"]).page(page).per(per_page)
    # @resultsに格納された検索結果からその生物の画像URLを収集するメソッド
    collect_image_urls(@results)
  end

  # 各種の taxonKey（タクソンキー→GBIFが生物の種や分類を特定するためのID番号） に対応する画像URLを取得
  def collect_image_urls(results)
    # 前回の検索結果の画像URLデータをクリアし、画像URLを格納するための空のハッシュを初期化（key: taxonKey、value: 画像URL）
    @image_urls = {}

    # 検索結果（results）を1件ずつ処理
    results.each do |species|
      # species（1件の種情報）から、GBIFが各分類群に割り当てている一意のID（key、taxonKeyのこと）を取得
      taxon_key = species["key"]
      # taxon_keyが存在しない場合は次へスキップ
      next unless taxon_key.present?
      # taxonKeyに対応する画像URLを取得し、@image_urlsに保存（key: taxonKey、value: 画像URL）
      @image_urls[taxon_key] = get_species_image_url(taxon_key)
    end

  end
    
  # キーワードが存在しない場合、検索結果を初期化する処理
  def reset_search_results
    # APIからのレスポンスデータをnil（空）にする
    @response = nil
     # 検索結果を空にする
    @results = []
    # 画像URLを格納するハッシュを空にする
    @image_urls = {}
  end

end
