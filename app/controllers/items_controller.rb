class ItemsController < ApplicationController
  before_action :parent_category
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_action :user_items, only: [:show, :destroy]
  before_action :select_category_and_serch_ancestry, only: [:edit, :update]
  before_action :set_categories, only: [:new, :create, :edit, :update]

  def index
    @items = Item.all.order("created_at DESC").limit(8)
  end

  def new
    @item = Item.new
    @item.images.new
  end

  def create
    if item_params[:images_attributes].present?
      @item = Item.new(item_params)
      if@item.images.length <= 10
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
    else
      redirect_to new_item_path
    end
  end

  def show
  end

  def edit
  end

  def update
    if item_params[:images_attributes].present?
      if @item.images.length <= 10
        if @item.update(item_params)
          brands = Brand.find_or_create_by(name: params[:item][:brand])
          @item.update(brand_id: brands.id)
          redirect_to item_path(@item)
        else
          render :edit
        end
      else
        render :edit
      end
    else
      render :edit
    end
  end

  def destroy
    if @item.destroy
      redirect_to user_path(current_user.id), notice: '削除が完了しました'
    else
      render :show, alert: '削除が失敗しました'
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

  def set_item
    @item = Item.find(params[:id])   
  end

  def select_category_and_serch_ancestry
    @category = Category.find(@item.category_id)
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

  def user_items
    @items = Item.where(user_id: @item.user_id).order("created_at DESC").limit(6)
  end

  def set_categories
    @categories = @categories.pluck(:name, :id)
  end
end
