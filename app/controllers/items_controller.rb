class ItemsController < ApplicationController
  def index
  end

  def new
    @categories = Category.where(ancestry: nil).pluck(:name, :id)
  end

  def create
  end

  def show
  end

  private

  def item_params
    params.require(:item).permit(:name, :detail, :price, :status, :pay_side, :post_date, brand_attributes: [:id, :name], category_attributes: [:id, :name, :ancestry]).merge(user_id: current_user.id)
  end
end
