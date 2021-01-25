class PostComment < ApplicationRecord
  belongs_to :user
  belongs_to :cook
  has_many :notifications, dependent: :destroy

  validates :comment, presence: true
end
