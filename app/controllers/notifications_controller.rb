class NotificationsController < ApplicationController
  def destroy_all
    # 通知を全削除
    @notifications = current_user.passive_notifications.destroy_all
    redirect_to mypage_path
  end
end
