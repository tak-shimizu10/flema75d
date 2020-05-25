class ItemsController < ApplicationController
  before_action :set_item, except: [:index, :new, :create]

  def index
  end

  def new
    @categories = Category.where(ancestry: nil).pluck(:name, :id)
    @item = Item.new
    @item.images.new
  end

  def create
    # binding.pry
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

  def update
    if @item.update(item_params)
      redirect_to root_path
    else
      render :edit
    end
  end

  private

  def item_params
    params.require(:item).permit(:id, :name, :detail, :price, :status, :pay_side, :post_date, :brand_id, :category_id, :prefecture_id, images_attributes: [:image]).merge(user_id: current_user.id)
  end

  def set_item
    @item = Item.find(params[:id])
  end
end
