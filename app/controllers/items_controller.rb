class ItemsController < ApplicationController
  include ItemsHelper

  def index
  end

  def new
    @categories = Category.where(ancestry: nil).pluck(:name, :id)
    @item = Item.new
    @item.images.new
  end

  def create
    item_params_present_create
  end

  def show
  end

  private

  def item_params
    params.require(:item).permit(:id, :name, :detail, :price, :status, :pay_side, :post_date, :brand_id, :category_id, :prefecture_id, images_attributes: [:image]).merge(user_id: current_user.id)
  end

  def item_params_present_create
    if item_params.require(:images_attributes).present?
      @item = Item.new(item_params)
      brands = Brand.find_or_create_by(name: params[:item][:brand])
      @item.update!(brand_id: brands.id)
      if @item.save
        respond_to do |format|
          format.js { render ajax_redirect_to(root_path) }
        end
      else
        render :new
      end
    else
      render :new
    end
  end
end
