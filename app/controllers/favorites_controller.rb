class FavoritesController < ApplicationController
  def create
    @cook = Cook.find(params[:cook_id])
    favorite = @cook.favorites.new(user_id: current_user.id)
    favorite.save
    # app/views/favorites/create.js.erbを参照する
    # cook.rbで定義した通知機能メソッド
    @cook.create_notification_favorite!(current_user)
  end

  def destroy
    @cook = Cook.find(params[:cook_id])
    favorite = @cook.favorites.find_by(user_id: current_user.id)
    favorite.destroy
    # app/views/favorites/destroy.js.erbを参照する
  end
end
