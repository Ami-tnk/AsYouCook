class CooksController < ApplicationController
  # ログインユーザー以外の方は料理一覧や料理詳細画面は見れるように設定
  before_action :authenticate_user!, except: [:index, :show]

  def index
    # 検索オブジェクトを生成
    @q = Cook.ransack(params[:q])
    # 検索結果(公開中データを表示)
    @cooks = @q.result(distinct: true).where(is_active: "true").order(updated_at: "DESC").
      page(params[:page])
  end

  def show
    if user_signed_in?
      @cook = Cook.find(params[:id])
      @tags = @cook.tags.limit(3)
      @user = User.find(@cook.user_id)
      @post_comment = PostComment.new
      # 未確認の通知があれば、通知先の投稿詳細画面まで行くと確認済みになるようにする
      @unchecked_notifications = current_user.passive_notifications.
        where(cook_id: @cook.id, checked: false)
      @unchecked_notifications.each do |notification|
        notification.update_attributes(checked: true)
      end
    else
      # ユーザ登録,ログインしていない人用(作成ユーザー名リンクをクリックしたらログイン画面に遷移)
      @cook = Cook.find(params[:id])
      @user = User.find(@cook.user_id)
    end
  end

  def create
    @cook = Cook.new(cook_params)
    @cook.user_id = current_user.id
    if @cook.save
      tags = Vision.get_image_data(@cook.image, false)
      tags.each do |tag|
        # Food, Recipe, Tableware, Ingredent とついたTagは保存しない
        if tag["description"] != "Food" \
          and tag["description"] != "Recipe" \
          and tag["description"] != "Tableware" \
          and tag["description"] != "Ingredient"
          @cook.tags.create(name: tag["description"], score: (tag["score"] * 100))
        end
      end
      redirect_to mypage_path, notice: "料理を投稿しました!"
    else
      redirect_to "/mypage", flash:
        { errors: @cook.errors, error_full_messages: @cook.errors.full_messages }
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
    @cook = Cook.find(params[:id])
    if @cook.update(cook_params)
      redirect_to cook_path(@cook.id), notice: "料理を編集しました!"
    else
      render 'edit'
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
    params.require(:cook).permit(:cooking_name, :image, :recipe, :is_active)
  end
end
