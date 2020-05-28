class ItemsController < ApplicationController
  def index
    @categories = Category.where(ancestry: nil)
  end

  def new
    @categories = Category.where(ancestry: nil).pluck(:name, :id)
    @item = Item.new
    @item.images.new
  end

  def create
    if item_params[:images_attributes].present?
      @item = Item.new(item_params)
      brands = Brand.find_or_create_by(name: params[:item][:brand])
      @item.update!(brand_id: brands.id)
      redirect_to root_path
    else
      @categories = Category.where(ancestry: nil).pluck(:name, :id)
      render :new
    end
  end

  def show
  end

  private

  def item_params
    params.require(:item).permit(:id, :name, :detail, :price, :status, :pay_side, :post_date, :brand_id, :category_id, :prefecture_id, images_attributes: [:image]).merge(user_id: current_user.id)
  end
end
