class Address < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions

  belongs_to :user, optional: true
  belongs_to_active_hash :prefecture

  VALID_ZIPCODE_REGEX = /\A\d{3}-?\d{4}\z/i
  validates :zipcode, presence: true,
            # 数字(3)文字、ハイフン(-)省略可、数字(4)文字になっているか
            format: { with: VALID_ZIPCODE_REGEX, message: "ハイフンを入れて半角数字で入力してください" }
  validates :prefecture_id, :city, :address, presence: true
end
