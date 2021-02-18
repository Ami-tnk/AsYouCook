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
    search = tags.map {|tag| tag["description"]}.first(5)

    if !search.nil?
      @tags = Tag.where(name: search).select(:cook_id).distinct
    else
      redirect_to search_show_path, alert: "ヒットするレシピがありませんでした。"
    end
    @cooks = Cook.find(Cook.pluck(:id).shuffle[0..4])
  end

  private

  def cook_params
    params.require(:cook).permit(:image)
  end
end
