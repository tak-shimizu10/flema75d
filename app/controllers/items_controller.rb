class ItemsController < ApplicationController
  def index
  end

  def new
    @categories = Category.where(ancestry: nil).pluck(:name, :id)
    @item = Item.new
    @item.images.build
  end

  def create
    @item = Item.new(item_params)
    brands = Brand.find_or_create_by(name: params[:item][:brand])
    @item.update!(brand_id: brands.id)
    if @item.save
      redirect_to root_path
    else
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
