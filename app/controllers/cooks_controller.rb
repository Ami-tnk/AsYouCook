class CooksController < ApplicationController
  before_action :authenticate_user!, except: [:index]

  def index
    @cooks
    # 検索オブジェクトを生成
    @q = Cook.ransack(params[:q])
    # 検索結果(公開中データを表示)
    @cooks = @q.result(distinct: true).where(is_active: "true")
  end

  def show
    @cook = Cook.find(params[:id])
    @user = User.find(@cook.user_id)
    @post_comment = PostComment.new
  end

  def create
    @cook = Cook.new(cook_params)
    @cook.user_id = current_user.id
    if @cook.save
      redirect_to mypage_path, notice: "料理を投稿しました!"
    else
      @cook = Cook.new
      @user = User.find(current_user.id)
      @q = @user.cooks.ransack(params[:q])
      # 検索結果(公開中データを表示)
      @cooks = @q.result(distinct: true).order(created_at: "DESC").page(params[:page])
      @favorite_cooks = @user.favorite_cooks
      @notifications = current_user.passive_notifications
      flash.now[:alert] = "投稿に失敗しました。もう一度行ってください。"
      render 'users/mypage'
    end
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
    if cook.update(cook_params)
      redirect_to cook_path(cook.id), notice: "料理を編集しました!"
    else
      redirect_back(fallback_location: root_path, alert: "投稿に失敗しました。もう一度行ってください。")
    end
  end

  def destroy
    cook = Cook.find(params[:id])
    cook.destroy
    redirect_to mypage_path, notice: "投稿が削除されました。"
  end

  # 投稿データのストロングパラメーター
  private

  def cook_params
    params.require(:cook).permit(:cooking_name, :image, :description, :is_active)
  end
end
