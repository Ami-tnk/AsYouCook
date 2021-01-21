class UsersController < ApplicationController
  before_action :authenticate_user!

  def mypage
    @cook = Cook.new
    @user = User.find(current_user.id)
    @cooks = @user.cooks.all
  end

  def show
    @user = User.find_by(nickname: params[:nickname])
    if @user == current_user
      redirect_to mypage_path                     # 自身のページはmypageに遷移するように設定
    end
    @cooks = @user.cooks.where(is_active: "true") # 公開中の料理のみ表示
  end

  def edit
    @user = User.find_by(nickname: params[:nickname])
    if @user.nickname == current_user.nickname
      render "edit"                           # ログインユーザーのみ編集画面に遷移できるよう設定
    else
      redirect_to mypage_path                 # ログインユーザーでなかったらmypageに遷移
    end
  end

  def update
    user = User.find(current_user.id)
    user.update(user_params)
    redirect_to mypage_path
  end

  def index
    @users = User.all
  end

  def destroy
    user = User.find(current_user.nickname)
    user.destroy
    flash[:success] = "ありがとうございました。またのご利用を心よりお待ちしております。"
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:nickname, :profile_image, :introduction)
  end
end
