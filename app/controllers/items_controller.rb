class ItemsController < ApplicationController
  before_action :parent_category, only: [:index, :new, :create, :show]

  def index
  end

  def new
    @categories = @categories.pluck(:name, :id)
    @item = Item.new
    @item.images.new
  end

  def create
    if item_params[:images_attributes].present?
      @item = Item.new(item_params)
      if @item.save
        brands = Brand.find_or_create_by(name: params[:item][:brand])
        @item.update!(brand_id: brands.id)
        redirect_to root_path
      else
        @categories = Category.where(ancestry: nil).pluck(:name, :id)
        render :new
      end
    else
      @categories = @categories.pluck(:name, :id)
      render :new
    end
  end

  def show
  end

  def edit
    @item = Item.find(params[:id])
    @brand = Brand.find(@item[:brand_id])
    @images = Image.where(item_id: params[:id])
    # binding.pry
    @categories = Category.where(id: Item.find(params[:id])[:category_id]).pluck(:name, :id)
  end

  def update
  end

  private

  def parent_category
    @categories = Category.where(ancestry: nil)
  end

  def item_params
    params.require(:item).permit(:id, :name, :detail, :price, :status, :pay_side, :post_date, :brand_id, :category_id, :prefecture_id, :post_way_id, images_attributes: [:image]).merge(user_id: current_user.id)
  end
end
