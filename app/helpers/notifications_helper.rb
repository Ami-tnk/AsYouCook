module NotificationsHelper
  def notification_form(notification)
    your_post = link_to '投稿', notification.cook, style: "font-weight: bold;"
    case notification.action
    when "post_comment"
      "#{your_post}にコメントがあります！"
    when "favorite"
      "#{your_post}がお気に入り登録されました！"
    end
  end
end
