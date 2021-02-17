class SearchesController < ApplicationController
  def show
    @cook = Cook.new
    @cooks = Cook.find(Cook.pluck(:id).shuffle[0..4])
    render "search"
  end

  def search
    cook = Cook.new(cook_params)
    # Vision APIでのタグ付け
    tags = Vision.get_image_data(cook.image, true)
    tags.each do |tag|
      # FoodとついたTagは保存しない
      if tag["description"] != "Food"
        search_tags = tag(name: tag["description"], score: (tag["score"] * 100))
      end
    end

    if params[:search]
      @tags = Tag.where('name', "{params[:search]}")
      @cooks = Cook.find(Cook.pluck(:id).shuffle[0..4])
    else
      flash[:notice] = "ヒットする料理がありませんでした"
      #適するレシピがなかったら他のレシピをランダムに5つ
      @cooks = Cook.find(Cook.pluck(:id).shuffle[0..4])
    end
  end

  def cook_params
    params.require(:cook).permit(:image)
  end
end
