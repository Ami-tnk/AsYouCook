class HomesController < ApplicationController
  def top
    @cooks = Cook.where(is_active: true).limit(5).order(created_at: :DESC)   #:DESC => 新着順に4つの商品を取り出す
  end
end
