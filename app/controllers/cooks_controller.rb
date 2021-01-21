class CooksController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @cooks = Cook.where(is_active: "true") # 公開中の料理のみ表示
  end

  def show
    @cook = Cook.find(params[:id])
    @user = User.find(@cook.user_id)
  end

  def create
    @cook = Cook.new(cook_params)
    @cook.user_id = current_user.id
    @cook.save
    redirect_to mypage_path
  end

  def edit
    @cook = Cook.find(params[:id])
    if @cook.user_id == current_user.id
      render :edit
    else
      redirect_back(fallback_location: root_path)
    end
  end

  def update
    cook = Cook.find(params[:id])
    cook.update(cook_params)
    redirect_to cook_path(cook.id)
  end

  def destroy
    cook = Cook.find(params[:id])
    cook.destroy
    flash[:success] = "投稿が削除されました。"
    redirect_to mypage_path
  end

  # 投稿データのストロングパラメーター
  private

  def cook_params
    params.require(:cook).permit(:cooking_name, :image, :description, :is_active)
  end
end
