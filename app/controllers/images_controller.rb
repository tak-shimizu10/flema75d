class ImagesController < ApplicationController
  
  def create
    @item = Item.find(params[:item_id])
    @image = @item.images.new(image_params)
    @image.create
  end
  private
  def image_params
    params.require(:image).permit(:image).maerge(item_id: )
  end
end
