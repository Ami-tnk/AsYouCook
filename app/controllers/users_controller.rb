class UsersController < ApplicationController
  before_action :authenticate_user!

  def mypage
    @cook = Cook.new
    @user = User.find(current_user.id)
    # 検索オブジェクトを生成
    @q = @user.cooks.ransack(params[:q])
    # 検索結果(公開中データを投稿が新しいものから表示)
    @cooks = @q.result(distinct: true).order(created_at: "DESC").page(params[:page])

    @favorite_cooks = @user.favorite_cooks
    @notifications = current_user.passive_notifications.order("created_at DESC")
  end

  def show
    # users/:nicknameでroutes作成しているためnicknameでUser検索
    @user = User.find_by(nickname: params[:nickname])
    # 自身のページはmypageに遷移するように設定
    if @user == current_user
      redirect_to mypage_path
    end
    # 他ユーザーの料理情報は公開中の料理のみ表示
    @cooks = @user.cooks.where(is_active: "true")
  end

  def edit
    # users/:nicknameでroutes作成しているためnicknameでUser検索
    @user = User.find_by(nickname: params[:nickname])
    # ログインユーザーのみ編集画面に遷移できるよう設定, 他ユーザはmypageに遷移
    if @user.nickname != current_user.nickname
      redirect_to mypage_path
    end
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to mypage_path, notice: "アカウントを編集しました！"
    else
      flash.now[:alert] = "編集できませんでした。もう一度行ってください。"
      @user = User.find_by(nickname: current_user.nickname)
      render "edit"
    end
  end

  def index
    @users = User.all
  end

  def destroy
    user = User.find_by(nickname: params[:nickname])
    user.destroy
    redirect_to root_path, notice: "ありがとうございました。またのご利用を心よりお待ちしております。"
  end

  private

  def user_params
    params.require(:user).permit(:nickname, :email, :profile_image, :introduction)
  end
end
