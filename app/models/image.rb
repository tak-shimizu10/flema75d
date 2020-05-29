class Image < ApplicationRecord
  belongs_to :item
  mount_uploader :image, ImageUploader

  validates :image, length: { minimum: 1, maximum: 10 }
end
