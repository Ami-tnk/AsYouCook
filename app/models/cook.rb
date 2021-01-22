class Cook < ApplicationRecord
  attachment :image
  belongs_to :user
  validates :image, presence: true
end
