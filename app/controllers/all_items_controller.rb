class AllItemsController < ApplicationController
  before_action :parent_category, only: [:index,:category]
  def index
    @items = Item.all.order("created_at DESC")
  end
  
  def category
    @category = Category.find(params[:category_id])
  end

  private

  def parent_category
    @categories = Category.where(ancestry: nil)
  end
end
