class Cook < ApplicationRecord
  attachment :image

  belongs_to :user
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :notifications, dependent: :destroy

  # 引数で渡されたユーザidがfavoriteテーブル内に存在するか調べるメソッド
  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  # 写真は空投稿は不可
  validates :image, presence: true
end
