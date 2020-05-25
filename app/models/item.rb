class Item < ApplicationRecord
  has_many :images, dependent: :destroy
  accepts_nested_attributes_for :images, allow_destroy: true
  belongs_to :user
  belongs_to :category
  belongs_to :brand, optional: true

  enum status: { brand_new: 1, like_new: 2, invisible_dirt: 3, a_little_dirt: 4, dirt_condition: 5, bad_condition: 6 }
  enum pay_side: { seller: 1, buyer: 2 }
  enum post_date: { shortest: 1, normal: 2, longest: 3 }
  enum situation: { exhibition: 0, transaction: 1, purchase: 2 }, _prefix: true

  validates :images, associated: true
  validates :name, :detail, :status, :pay_side, :post_date, :price, presence: true
  validates :prefecture_id, :category_id, numericality: { other_than: 0 }
  class << self
    def localed_statuses
      statuses.keys.map do |k|
        [I18n.t("enums.Item.status.#{k}"), k]
      end
    end

    def localed_pay_sides
      pay_sides.keys.map do |k|
        [I18n.t("enums.Item.pay_side.#{k}"), k]
      end
    end

    def localed_post_dates
      post_dates.keys.map do |k|
        [I18n.t("enums.Item.post_date.#{k}"), k]
      end
    end
  end
end
