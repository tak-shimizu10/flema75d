class Address < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions

  belongs_to :user, optional: true
  belongs_to_active_hash :prefecture
  validates :zipcode, :prefecture_id, :city, :address, presence: true
end
