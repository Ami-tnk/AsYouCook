class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  attachment :profile_image

  has_many :cooks, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_cooks, through: :favorites, source: :cook
  has_many :active_notifications, class_name: 'Notification',
                                  foreign_key: 'visitor_id', dependent: :destroy
  has_many :passive_notifications, class_name: 'Notification',
                                   foreign_key: 'visited_id', dependent: :destroy

  # nicknameは重複不可に設定
  validates :nickname, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
end
