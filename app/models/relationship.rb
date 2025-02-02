class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  #Rails5では以下のvalidatesは必須ではなくなったらしい
  validates :follower_id, presence: true
  validates :followed_id, presence: true
end
