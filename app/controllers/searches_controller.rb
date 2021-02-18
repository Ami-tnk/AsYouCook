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
      # Vision APIでのタグ付け
    end
    tags = Vision.get_image_data(cook.image, true)

    search = tags.map {|tag| tag["description"]}.first(3)

    if !search.nil?
      @tags = Tag.where(name: search).select(:cook_id).distinct
    else
      flash[:alert] = "ヒットするレシピがありませんでした"
      #適するレシピがなかったら他のレシピをランダムに5つ
    end
    @cooks = Cook.find(Cook.pluck(:id).shuffle[0..4])
  end

  def cook_params
    params.require(:cook).permit(:image)
  end
end
