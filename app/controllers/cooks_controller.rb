class CooksController < ApplicationController
  before_action :authenticate_user!

  def index
    @cooks
    # 検索オブジェクトを生成
    @q = Cook.ransack(params[:q])
    # 検索結果(公開中データを表示)
    @cooks = @q.result(distinct: true).where(is_active: "true").order(updated_at: "DESC").page(params[:page])
  end

  def show
    @cook = Cook.find(params[:id])
    @user = User.find(@cook.user_id)
    @post_comment = PostComment.new
    # もし未確認の通知があれば、通知先の投稿詳細画面まで行くと確認済みになるようにする
    if  @unchecked_notifications = current_user.passive_notifications.where(cook_id: @cook.id, checked: false)
      @unchecked_notifications.each do |notification|
        notification.update_attributes(checked: true)
      end
    end
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
      # 検索結果(公開中データを投稿(更新)が新しいものから表示)
      @cooks = @q.result(distinct: true).order(updated_at: "DESC").page(params[:page])
      # お気に入りに入れたデータを取り出す
      @favorite_cooks = @user.favorite_cooks
      # 「いいね」か「コメント」をもらったら通知
      @notifications = current_user.passive_notifications.order("created_at DESC")
      # 未確認通知を取り出す
      @unchecked_notifications = current_user.passive_notifications.where(checked: false)
      flash.now[:alert] = "投稿に失敗しました。料理写真は投稿が必須です。"
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
