class Image < ApplicationRecord
  has_many :items
  mount_uploader :image, ImagesUploader
end
