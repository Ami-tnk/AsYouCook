class UsersController < ApplicationController
  def mypage
    @cook = Cook.new
    @user = User.find(current_user.id)
    @cooks = @user.cooks.all
  end

  def show
    @user = User.find_by(nickname: params[:nickname])
    if @user == current_user
      redirect_to mypage_path                     #自身のページはmypageに遷移するように設定
    end
    @cooks = @user.cooks.where(is_active: "true") #公開中の料理のみ表示
  end

  def edit
  end

  def update
  end

  def index
  end

  def destroy
  end

end
