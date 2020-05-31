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
    @category = @item.category
    @categories = Category.where(ancestry: nil).pluck(:name, :id)
    if @category.parent.present?
      @child_category = @category
      @category = @child_category.parent
      if @category.parent.present?
        @grandchild_category = @child_category
        @child_category = @category
        @category = @child_category.parent
      else
        render :edit
      end
    else
      render :edit
    end
  end

  def update
    @item = Item.find(params[:id])
    if item_params[:images_attributes].present?
      if @item.update_attributes(item_params)
        brands = Brand.find_or_create_by(name: params[:item][:brand])
        @item.update(brand_id: brands.id)
        redirect_to root_path
      else
        render :edit
      end
    else
      render :edit
    end
  end

  private

  def parent_category
    @categories = Category.where(ancestry: nil)
  end

  def item_params
    params.require(:item)
          .permit(:id, :name, :detail, :price, :status, :pay_side, :post_date, :category_id, :prefecture_id, :post_way_id, images_attributes: [:id, :image, :item_id, :_destroy])
          .merge(user_id: current_user.id)
  end
end
