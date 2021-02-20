class SearchesController < ApplicationController
  def show
    @cook = Cook.new
    @cooks = Cook.find(Cook.pluck(:id).shuffle[0..4])
    render "search"
  end

  def search
    @cook = Cook.new
    cook = Cook.new(cook_params)
    if cook.image.nil?
      redirect_to search_show_path, alert: "画像を選択してください。"
      return
    end
    # Vision APIでのタグ付け
    tags = Vision.get_image_data(cook.image, true)
    select_tags = tags.select{ |tag|
      (tag["description"] != "Food") \
      && (tag["description"] != "Recipe") \
      && (tag["description"] != "Tableware") \
      && (tag["description"] != "Ingredient") \
      && (tag["description"] != "Cuisine") \
      && (tag["description"] != "Dish") \
      && (tag["description"] != "Cooking")
    }
    @search = select_tags.map { |tag| tag["description"] }.first(3)

    if !@search.nil?
      @tags = Tag.where(name: @search).select(:cook_id).distinct
      if @tags.count == 0
        redirect_to search_show_path, alert: "ヒットするレシピがありませんでした。"
      end
    end
    @cooks = Cook.find(Cook.pluck(:id).shuffle[0..4])
  end

  private

  def cook_params
    params.require(:cook).permit(:image)
  end
end
