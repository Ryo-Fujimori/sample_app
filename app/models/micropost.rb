class Micropost < ApplicationRecord
  # ユーザーと1対1の関係であることを表す
  belongs_to :user
  #アップロードされたファイル1つと関連付けする
  #画像のリサイズ
  has_one_attached :image do |attachable|
    attachable.variant :display, resize_to_limit: [500, 500]
  end  
  #表示順の設定
  default_scope -> { order(created_at: :desc) }

  # user_idの検証
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validates :image,   content_type: { in: %w[image/jpeg image/gif image/png],
                                      message: "must be a valid image format" },
                      size:         { less_than: 5.megabytes,
                                      message:   "should be less than 5MB" }
end
