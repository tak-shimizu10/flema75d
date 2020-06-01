class ItemsController < ApplicationController
  before_action :parent_category, only: [:index, :new, :create, :show]

  def index
    @items = Item.all.order("created_at DESC").limit(8)
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
        redirect_to new_item_path
      end
    else
      redirect_to new_item_path
    end
  end

  def show
    @item = Item.find(params[:id])
    @items = Item.where(user_id: @item.user_id).order('created_at DESC').limit(6)
  end

  def edit
    @item = Item.find(params[:id])
    @category = Category.find(@item.category_id)
    @categories = Category.where(ancestry: nil).pluck(:name, :id)
    select_category_and_serch_ancestry
  end

  def update
    @item = Item.find(params[:id])
    if item_params[:images_attributes].present?
      if @item.update(item_params)
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

  def select_category_and_serch_ancestry
    if @category.parent.present?
      @child_category = Category.find(@category.id)
      @category = @child_category.parent
      if @category.parent.present?
        @grandchild_category = @child_category
        @child_category = @category
        @category = @child_category.parent
        @child_categories = Category.where(ancestry: @category.id).pluck(:name, :id)
        @grandchild_categories = Category.where(ancestry: @grandchild_category[:ancestry]).pluck(:name, :id)
      else
        @child_categories = Category.where(ancestry: @category.id).pluck(:name, :id)
        render :edit
      end
    else
      @child_categories = Category.where(ancestry: @category.id).pluck(:name, :id)
      render :edit
    end
  end
end
