class Cook < ApplicationRecord
  attachment :image

  validates :image, presence: true
  validates :cooking_name, presence: true
  validates :recipe, presence: true

  belongs_to :user
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :notifications, dependent: :destroy

  # 引数で渡されたユーザidがfavoriteテーブル内に存在するか調べるメソッド
  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  # 「いいね」の通知機能メソッド
  def create_notification_favorite!(current_user)
    # すでに「いいね」されているか検索し、tempに一時的に保管
    temp = Notification.where([
      "visitor_id = ? and visited_id = ? and cook_id = ? and action = ? ",
      current_user.id, user_id, id, 'favorite',
    ])
    # 「いいね」されていない場合のみ、通知レコードを作成
    if temp.blank?
      notification = current_user.active_notifications.new(
        cook_id: id,
        visited_id: user_id,
        action: 'favorite'
      )
      # 自分が自分の投稿に対する「いいね」は、通知済みとする
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save
    end
  end

  # 「コメント」の通知機能メソッド
  def create_notification_post_comment!(current_user, post_comment_id)
    # 自分以外にコメントしている人をすべて取得し、全員に通知を送る
    temp_ids = PostComment.select(:user_id).
      where(cook_id: id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
      save_notification_comment!(current_user, post_comment_id, temp_id['user_id'])
    end
    # まだ誰もコメントしていない場合は、投稿者に通知を送る
    save_notification_comment!(current_user, post_comment_id, user_id) if temp_ids.blank?
  end

  def save_notification_comment!(current_user, post_comment_id, visited_id)
    # １つの投稿に複数回通知する
    notification = current_user.active_notifications.new(
      cook_id: id,
      post_comment_id: post_comment_id,
      visited_id: visited_id,
      action: 'post_comment'
    )
    # 自分の投稿に対するコメントの場合は、通知済みとする
    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end
end
