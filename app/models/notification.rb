class Notification < ApplicationRecord
  # optional:trueでnilの許可
  belongs_to :cook, optional: true
  belongs_to :post_comment, optional: true

  # 通知を送ったユーザーのid
  belongs_to :visitor, class_name: 'User', foreign_key: 'visitor_id', optional: true
  # 通知を送られたユーザーのid
  belongs_to :visited, class_name: 'User', foreign_key: 'visited_id', optional: true
end
