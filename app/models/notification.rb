class Notification < ApplicationRecord
  # 並び順「作成日時の降順」に指定
  default_scope -> { order(created_at: :desc) }
  # optional:trueでnilの許可
  belongs_to :post, optional: true
  belongs_to :comment, optional: true

  belongs_to :visitor, class_name: 'User', foreign_key: 'visitor_id'
  belongs_to :visited, class_name: 'User', foreign_key: 'visited_id'
end
