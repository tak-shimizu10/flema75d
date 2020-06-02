class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
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

  has_one :address, dependent: :destroy
  has_many :cards, dependent: :destroy
  has_many :comments
  has_many :items
end
