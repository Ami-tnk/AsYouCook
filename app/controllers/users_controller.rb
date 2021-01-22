class UsersController < ApplicationController
  before_action :authenticate_user!

  def mypage
    @cook = Cook.new
    @user = User.find(current_user.id)
    @cooks = @user.cooks.all
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
    # ログインユーザーのみ編集画面に遷移できるよう設定
    if @user.nickname == current_user.nickname
      render "edit"
    else
    # ログインユーザーでなかったらmypageに遷移
      redirect_to mypage_path
    end
  end

  def update
    # updateできるのはcurrent_userのみの仕様であるためidで特定
    user = User.find(current_user.id)
    user.update(user_params)
    redirect_to mypage_path
  end

  def index
    @users = User.all
  end

  def destroy
    user = User.find_by(nickname: params[:nickname])
    user.destroy
    flash[:success] = "ありがとうございました。またのご利用を心よりお待ちしております。"
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:nickname, :profile_image, :introduction)
  end
end
