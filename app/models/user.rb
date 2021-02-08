class User < ApplicationRecord
  # 使用しているdevise modules
  devise :database_authenticatable, :registerable, :validatable

  attachment :profile_image

  has_many :cooks, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_cooks, through: :favorites, source: :cook
  # 「いいね」か「コメント」した時の通知
  has_many :active_notifications, class_name: 'Notification',
                                  foreign_key: 'visitor_id', dependent: :destroy
   # 「いいね」か「コメント」された時の通知
  has_many :passive_notifications, class_name: 'Notification',
                                   foreign_key: 'visited_id', dependent: :destroy

  # nickname, emailは重複不可に設定
  validates :nickname, presence: true, uniqueness: true, length: {maximum: 20}
  validates :email, presence: true, uniqueness: true
end
