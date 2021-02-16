class Cook < ApplicationRecord
  attachment :image

  validates :image, presence: true
  validates :cooking_name, presence: true
  validates :recipe, presence: true

  belongs_to :user
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :tags, dependent: :destroy

  # 引数で渡されたユーザidがfavoriteテーブル内に存在するか調べるメソッド
  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  # 「いいね」の通知機能メソッド
  def create_notification_favorite!(current_user)
    # 通知レコードを作成
    notification = current_user.active_notifications.new(
      cook_id: id,
      visited_id: user_id,
      action: 'favorite'
    )
    # 「いいね」された料理を投稿したユーザーと「いいね」したユーザーが違ければ通知保存することにする
    if notification.visitor_id != notification.visited_id
      notification.save
    end
  end

  # 「コメント」の通知機能メソッド
  def create_notification_post_comment!(current_user, post_comment_id)
    # 自分以外にコメントしている人をすべて取得し、全員に通知を送る
    comment_members = PostComment.select(:user_id).
      where(cook_id: id).where.not(user_id: current_user.id).distinct
    comment_members.each do |comment_member|
      save_notification_comment!(current_user, post_comment_id, comment_member['user_id'])
    end

    # まだ誰もコメントしていない場合は、投稿者に通知を送る
    if comment_members.blank?
      save_notification_comment!(current_user, post_comment_id, user_id)
    end
  end

  def save_notification_comment!(current_user, post_comment_id, visited_id)
    # 通知レコードを作成
    notification = current_user.active_notifications.new(
      cook_id: id,
      post_comment_id: post_comment_id,
      visited_id: visited_id,
      action: 'post_comment'
    )
    # 「コメント」された料理のユーザーと「コメント」したユーザーが違ければ通知を保存することにする
    if notification.visitor_id != notification.visited_id
      notification.save
    end
  end
end
