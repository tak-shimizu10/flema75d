class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:facebook, :google_oauth2]
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  VALID_PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]{7,100}+\z/i
  validates :nickname, :birthday, presence: true
  validates :email, presence: true, 
            # 重複不可
            uniqueness: { case_sensitive: false }, 
            # 英数字のみ可,@を挟んだemailの形になっているか
            format: { with: VALID_EMAIL_REGEX, message: "フォーマットが不適切です" }
  validates :password, presence: true, length: { minimum: 7 }, 
            # 英数字のみ可
            format: { with: VALID_PASSWORD_REGEX, message: "半角英数字で入力してください" }
  validates :first_name, :last_name, presence: true,
            # 全角のみ可
            format: { with: /\A[ぁ-んァ-ヶー一-龠]+\z/, message: "全角で入力してください" }
  validates :first_kana, :last_kana, presence: true,
            # カナのみ可
            format: { with: /\A([ァ-ン]|ー)+\z/, message: "全角カナで入力してください" }
  
  has_one  :address, dependent: :destroy
  has_many :sns_credentials, dependent: :destroy
  has_many :cards, dependent: :destroy
  has_many :items, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :like_items, through: :likes, source: :item
  has_many :evaluates, dependent: :destroy
  has_many :evaluate_items, through: :evaluates, source: :item

  def self.from_omniauth(auth)
    sns = SnsCredential.where(provider: auth.provider, uid: auth.uid).first_or_create
    # sns認証したことがあればアソシエーションで取得
    # 無ければemailでユーザー検索して取得orビルド(保存はしない)
    user = sns.user || User.where(email: auth.info.email).first_or_initialize(
      nickname: auth.info.name,
      email:    auth.info.email
    )
    # userが登録済みの場合はそのままログインの処理へ行くので、ここでsnsのuser_idを更新しておく
    if user.persisted?
      sns.user = user
      sns.save
    end
    { user: user, sns: sns }
  end

end