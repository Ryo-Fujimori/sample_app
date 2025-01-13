class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token

  before_save   :downcase_email
  # ユーザー作成前に有効化トークンとダイジェストを割り当てる
  before_create :create_activation_digest
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  has_secure_password

  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  class << self
    # 渡された文字列のハッシュ値を返す
    def digest(string)
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create(string, cost: cost)
    end

    # ランダムなトークンを返す
    # 返すのはbase64の22文字
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  # 永続的セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token
    # 　渡したトークンをもとにダイジェストを作成、保存する
    update_attribute(:remember_digest, User.digest(remember_token))
    remember_digest
  end

  # セッションハイジャック防止のためにセッショントークンを返す
  # この記憶ダイジェストを再利用しているのは単に利便性のため
  def session_token
    remember_digest || remember
  end

  # 渡されたトークンがDBのダイジェストと一致したらtrueを返す
  # sendメソッドを用いてメタプログラミングで、どのトークンでも認証できるようにする
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end

  private

    # メールアドレスをすべて小文字にする
    def downcase_email
      #self.email = email.downcase
      email.downcase!
    end

    # 有効化トークンとダイジェストを作成および代入する
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
  end
