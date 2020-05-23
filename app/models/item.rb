class Item < ApplicationRecord
  has_many :images, dependent: :destroy
  belongs_to :user
  belongs_to :category
  belongs_to :brand
  enum status: { brand_new: 1, like_new: 2, invisible_dirt: 3, a_little_dirt: 4, dirt_condition: 5, bad_condition: 6 }
  enum pay_side: { seller: 1, buyer: 2 }
  enum post_date: { shortest: 1, normal: 2, longest: 3 }
end
