class Public::UsersController < ApplicationController
  # ユーザーがログインしている場合のみ、各アクションを実行する（未ログイン時はリダイレクト）
  before_action :authenticate_user!
  # edit、update、destroyアクションの前に、ensure_correct_userメソッドを実行してアクセス制限を行う
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  # マイページの表示
  def mypage
    @user = current_user
    # 自分の投稿をページネーション付きで取得
    @user_posts = @user.posts.page(params[:page])
  end

  # ユーザーの詳細画面の表示
  def show
    @user = User.find(params[:id])
  end

  # マイプロフィール編集の表示
  def edit
  end

  # ユーザー更新処理
  def update
    
    if @user.update(user_params)
      flash[:notice] = "ユーザーの編集に成功しました。"
      # マイページに遷移
      redirect_to mypage_path(@user)
    else
      flash.now[:alert] = "ユーザーの編集に失敗しました。"
      # ユーザー編集画面を再度表示
      render :edit
    end

  end

  # ユーザー退会確認画面
  def unsubscribe
  end

  # ユーザー退会処理（ステータスの更新）
  def withdraw
    
    if current_user.update(is_active: false)
      flash[:notice] = "退会手続きが完了しました。ご利用いただきありがとうございました。"
      # セッション情報をすべて削除
      reset_session
      # Topページに遷移
      redirect_to root_path
    else
      flash[:alert] = "退会処理に失敗しました。もう一度お試しください。"
      # マイページに遷移
      redirect_to mypage_path
    end

  end


  private
  
    # ユーザーのストロングパラメータ（許可されたパラメータのみを取得）
    def user_params
      params.require(:user).permit(:email, :nickname, :user_image, :introduction)
    end

    # 該当ユーザーでない場合、アクセスを制限するメソッド
    def ensure_correct_user
      @user = User.find(params[:id])

      # @userが現在のユーザーではない場合（=他人の情報にアクセスする場合）
      unless @user == current_user
        flash[:alert] = "権限がありません"
        # Topページに遷移し、、不正アクセスを防止
        redirect_to root_path
      end

    end
end
