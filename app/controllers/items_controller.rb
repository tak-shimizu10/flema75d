class ItemsController < ApplicationController

  # ログインしてなければ、ログイン画面に映る
  before_action :authenticate_user!, except: [:index,:show,:search]

  before_action :parent_category
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_action :user_items, only: [:show, :destroy]
  before_action :select_category_and_serch_ancestry, only: [:edit, :update]
  before_action :set_categories, only: [:new, :create, :edit, :update]
  before_action :return_not_equal_user, only: [:edit, :update]
  helper Users

  def index
    @items = Item.all.limit(8).order("created_at DESC")
  end

  def new
    @item = Item.new
    @item.images.new
  end

  def create
    if item_params[:images_attributes].present? 
      
      @item = Item.new(item_params)
      return redirect_to new_item_path if @item.images.length > 10
      brand = Brand.find_or_create_by(name:params[:item][:brand])
      @item.brand_id = brand&.id

      if @item.save
        redirect_to root_path
      else
        redirect_to new_item_path
      end
    else
      redirect_to new_item_path
    end
  end

  def show
    @other_items = Item.where(user_id: @item.user_id).where.not(id: params[:id])
    @comment = Comment.new
    @comments = @item.comments.includes(:user)
  end

  def edit
  end

  def update
    images = keep_or_update_images(item_params[:images_attributes])
    if images.present? && images.length <= 10 
      brand = Brand.find_or_create_by(name:params[:item][:brand])
      brand_id = @item.brand&.id if brand.name.blank?
      @item.brand_id = brand&.id
      if  @item.update(item_params)
        if brand_id.present?
          brand = Brand.find(brand_id)
          brand.destroy if brand.items.blank?
        end
        redirect_to item_path(@item)
      else
        render :edit
      end
    else
      render :edit
    end
  end

  def destroy
    brand_id = @item.brand&.id
    if @item.destroy
      if brand_id.present?
        brand = Brand.find(brand_id)
        brand.destroy if brand.items.blank?
      end
      redirect_to user_path(current_user.id), error_check: '削除が完了しました'
    else
      render :show, alert: '削除が失敗しました'
    end
  end

  def search
    if params[:q].present?
    # 検索フォームからアクセスした時の処理
      @search_result_items = Item.search(params[:q][:keyword])
      @search = @search_result_items.ransack(search_params)
      @items = @search.result
      @keyword = params[:q][:keyword]
    else
    # 検索フォーム以外からアクセスした時の処理
      params[:q] = { sorts: 'id desc' }
      @search = Item.ransack()
      @items = Item.search(params[:keyword])
        @keyword = params[:keyword]
        respond_to do |format|
          format.html
          format.json
        end
    end
  end

  def search_params
    params.require(:q).permit(:sorts,:keyword)
    
    # 他のパラメーターもここに入れる
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
    return redirect_to root_path unless Item.exists?(params[:id])
    @item = Item.find(params[:id])   
  end

  def select_category_and_serch_ancestry
    @category = @item.category
    if @category.parent.present?
      @child_category = @category
      @category = @child_category.parent
      if @category.parent.present?
        @grandchild_category = @child_category
        @child_category = @category
        @category = @child_category.parent
        @child_categories = Category.where(ancestry: @category.id).pluck(:name, :id)
        @grandchild_categories = Category.where(ancestry: @grandchild_category[:ancestry]).pluck(:name, :id)
      else
        @child_categories = Category.where(ancestry: @category.id).pluck(:name, :id)
      end
    else
      @child_categories = Category.where(ancestry: @category.id).pluck(:name, :id)
    end
  end

  def user_items
    @items = Item.where(user_id: @item.user_id).order("created_at DESC").limit(6)
  end

  def set_categories
    @categories = @categories.pluck(:name, :id)
  end

  def keep_or_update_images(images)
    result = []
    images.each do |image|
      if image[1][:image] || image[1][:_destroy] == "0"
        result << image[1]
      end
    end
    return result
  end

  def return_not_equal_user
    if @item.user_id != current_user.id 
      return redirect_to item_path(@item) 
    end
  end
end