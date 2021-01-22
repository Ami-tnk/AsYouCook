class Cook < ApplicationRecord
  attachment :image

  belongs_to :user
  has_many :post_comments, dependent: :destroy

  # 写真は空投稿は不可
  validates :image, presence: true
end
