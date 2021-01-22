class FavoritesController < ApplicationController
  def create
    cook = Cook.find(params[:cook_id])
    favorite = current_user.favorites.new(cook_id: cook.id)
    favorite.save
    redirect_to cook_path(cook), notice: "いいねしました！"
  end

  def destroy
    cook = Cook.find(params[:cook_id])
    favorite = current_user.favorites.find_by(cook_id: cook.id)
    favorite.destroy
    redirect_to cook_path(cook)
  end
end
