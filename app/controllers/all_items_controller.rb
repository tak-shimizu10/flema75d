class AllItemsController < ApplicationController
  def index
  end
  def category
    @categories = Category.where(ancestry:nil)
    @category = Category.find(params[:category_id])
  end
end
