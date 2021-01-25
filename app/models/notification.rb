class Notification < ApplicationRecord
  # 並び順「作成日時の降順」に指定
  default_scope -> { order(created_at: :desc) }
  # optional:trueでnilの許可
  belongs_to :cook, optional: true
  belongs_to :post_comment, optional: true

  belongs_to :visitor, class_name: 'User', foreign_key: 'visitor_id', optional: true
  belongs_to :visited, class_name: 'User', foreign_key: 'visited_id', optional: true
end
