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
  has_many :evaluates, dependent: :destroy

  enum pay_side: { seller: 1, buyer: 2 }
  enum post_date: { shortest: 1, normal: 2, longest: 3 }
  enum status: { brand_new: 1, like_new: 2, invisible_dirt: 3, a_little_dirt: 4, dirt_condition: 5, bad_condition: 6 }
  enum situation: { exhibition: 0, transaction: 1, purchase: 2 }, _prefix: true

  validates_associated :images
  validates :name, :detail, :price, :pay_side, :post_date, :status, :prefecture_id, :post_way_id, :category_id, :situation, presence: true
  validates :name, length: { maximum: 40 }
  validates :detail, length: { maximum: 1000 }
  validates :prefecture_id, :category_id, numericality: { greater_than: 0 }
  validates :price, numericality: { greater_than_or_equal_to: 300, less_than: 10000000 }
  validates :brand_id, numericality: { greater_than: 0 }, allow_blank: true


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

  def self.search(search)
    return Item.all unless search
    Item.where('name LIKE(?)', "%#{search}%")
  end

  def change
    return Item.all unless search
    Item.where('name LIKE(?)', "%#{search}%")
    create_table :items do |t|
      t.integer :price, null: false
      t.timestamps
    end
  end
end
