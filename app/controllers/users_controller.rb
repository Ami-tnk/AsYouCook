class UsersController < ApplicationController
  def mypage
    @cook = Cook.new
    @user = User.find(current_user.id)
    @cooks = @user.cooks.all
  end

  def edit
  end

  def update
  end

  def show
  end

  def index
  end

  def destroy
  end

end
