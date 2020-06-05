class Item < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions

  has_many :images, dependent: :destroy
  accepts_nested_attributes_for :images, allow_destroy: true
  belongs_to :user
  belongs_to :category
  belongs_to :brand, optional: true
  belongs_to_active_hash :prefecture
  belongs_to_active_hash :post_way
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  enum pay_side: { seller: 1, buyer: 2 }
  enum post_date: { shortest: 1, normal: 2, longest: 3 }
  enum status: { brand_new: 1, like_new: 2, invisible_dirt: 3, a_little_dirt: 4, dirt_condition: 5, bad_condition: 6 }
  enum situation: { exhibition: 0, transaction: 1, purchase: 2, draft: 3 }, _prefix: true

  validates_associated :images, unless: :draft_item?
  validates :name, :detail, :price, :pay_side, :post_date, :status, :prefecture_id, :post_way_id, :category_id, :situation, presence: true, unless: :draft_item?
  validates :brand_id, numericality: { greater_than: 0 }, allow_blank: true
  validates :name, length: { maximum: 40 }
  validates :detail, length: { maximum: 1000 }
  with_options unless: :is_admin? do |admin|
    admin.validates :prefecture_id, :category_id, numericality: { greater_than: 0 }
    admin.validates :price, numericality: { greater_than_or_equal_to: 300, less_than: 10000000 }
  end
  ###下書き保存の時空を許可 ↓  下書き保存以外でvalidationをかける条件付与 ↑
  with_options if: :is_admin? do |admin|
    admin.validates :name, length: { maximum: 40 }, allow_blank: true
    admin.validates :detail, length: { maximum: 1000 }, allow_blank: true
    admin.validates :prefecture_id, :category_id, numericality: { greater_than: 0 }, allow_blank: true
    admin.validates :price, numericality: { greater_than_or_equal_to: 300, less_than: 10000000 }, allow_blank: true
  end

  def draft_item?
    item.situation == 3
  end

  ##
  def liked_by?(user)
    likes.where(user_id: user&.id).exists?
  end

  class << self
    def localed_statuses
      statuses.keys.map do |k|
        [I18n.t("enums.item.status.#{k}"), k]
      end
    end

    def localed_pay_sides
      pay_sides.keys.map do |k|
        [I18n.t("enums.item.pay_side.#{k}"), k]
      end
    end

    def localed_post_dates
      post_dates.keys.map do |k|
        [I18n.t("enums.item.post_date.#{k}"), k]
      end
    end
  end
end
