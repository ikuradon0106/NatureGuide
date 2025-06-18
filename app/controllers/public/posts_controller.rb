class Public::PostsController < ApplicationController
  # ユーザーがログインしている場合のみ、各アクションを実行する（未ログイン時はリダイレクト）
  before_action :authenticate_user!
  # edit、update、destroyアクションの前に、ensure_correct_userメソッドを実行してアクセス制限を行う
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  # 新規投稿の表示
  def new
    @post = Post.new
  end

  # 投稿一覧の表示
  def index
    @posts = Post.page(params[:page])
    @user = current_user
  end

  # 投稿詳細の表示(HTMLやJSONに対応）
  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
    @comments = @post.comments.page(params[:page]).per(3)

    # リクエストのレスポンス形式によってRailsが返す処理を切り替える（APIとしてJSONを使いたいための記述）
    respond_to do |format|
      # HTML形式でレスポンスを返す場合→通常の処理で返す
      format.html
      # JSON形式でレスポンスを返す場合
      # format.json { render 'show' }
      format.json do
        # show.json..jbuilderを表示させる（as_jsonで@postをハッシュ形式のJSONに変換）
        render json: @post.as_json(only: [:id, :title, :body, :latitude, :longitude, :address])
      end

    end
    
  end

  # 投稿データの保存
  def create
      @post = Post.new(post_params)
      # 投稿にユーザー情報を紐付ける
      @post.user = current_user  

      # 投稿した画像を Vision.get_image_data(list_params[:image]) でAPI側に渡す
      tags = Vision.get_image_data(post_params[:image])
    
      if @post.save
        # 
        tags.each do |tag|
          @post.tags.create(name: tag)
        end
        flash[:notice] = "投稿が成功しました。"
        # 投稿詳細ページへ遷移
        redirect_to post_path(@post)  
      else
        flash.now[:alert] = "投稿に失敗しました。入力内容をご確認ください。"
        # 新規投稿画面を再度表示
        render :new 
      end
    
  end

  # 投稿の編集画面
  def edit
    @post = Post.find(params[:id])
  end

  # 投稿の更新処理
  def update
    @post = Post.find(params[:id])

    if @post.update(post_params)
      flash[:notice] = "編集に成功しました。"
      # 投稿詳細ページへ遷移
      redirect_to post_path(@post)
    else
      flash.now[:alert] = "編集に失敗しました。"
      # 投稿編集ページを再度表示
      render :edit
    end

  end

  # 投稿の削除処理
  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    # 削除後、投稿一覧ページへ遷移
    redirect_to posts_path
  end

  private
    # 投稿データのストロングパラメータ（許可されたパラメータのみを取得）
    def post_params
      params.require(:post).permit(:title, :body, :image, :address, :latitude, :longitude)
    end

    # 投稿者でない場合、アクセスを制限するメソッド
    def ensure_correct_user
      @post = Post.find(params[:id])

      # @postに紐づくユーザーが現在のユーザーではない場合（=他人の情報にアクセスする場合）
      unless @post.user == current_user
        flash[:alert] = "権限がありません"
        # 投稿一覧ページに遷移し、不正アクセスを防止
        redirect_to posts_path
      end

    end

end
