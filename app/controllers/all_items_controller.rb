class AllItemsController < ApplicationController
  before_action :parent_category, only: [:index,:new,:create,:show]
  def index
    @items = Item.all.order("created_at DESC")
  end

  private

  def parent_category
    @categories = Category.where(ancestry: nil)
  end

end
