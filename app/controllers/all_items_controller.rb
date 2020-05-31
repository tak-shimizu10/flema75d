class AllItemsController < ApplicationController
  before_action :parent_category, only: [:index,:new,:create,:show]
  def index
    @items = Item.all.order("created_at DESC")
  end
  
  def category
    @categories = Category.where(ancestry:nil)
    @category = Category.find(params[:category_id])
  end

  private

  def parent_category
    @categories = Category.where(ancestry: nil)
  end
end
