class CooksController < ApplicationController
  def index
    @cooks = Cook.where(is_active: "true") #公開中の料理のみ表示
  end

  def show
  end

  def create
    @cook = Cook.new(cook_params)
    @cook.user_id = current_user.id
    @cook.save
    redirect_to mypage_path
  end

  def edit
  end

  def update
  end

  def destroy
  end

  #投稿データのストロングパラメーター
  private

  def cook_params
    params.require(:cook).permit(:cooking_name, :image, :description, :is_active)
  end
end
