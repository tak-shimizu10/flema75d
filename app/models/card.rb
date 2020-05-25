class Card < ApplicationRecord

  belongs_to :user

  # 入力情報のバリデーション
  validates :customer_id , presence: true
  validates :card_id , presence: true, uniqueness: true

end
