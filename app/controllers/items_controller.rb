class ItemsController < ApplicationController
  def index
  end

  def new
    @categories = Category.where(ancestry:nil).pluck(:name,:id)
  end

  def create
  end

  def show
    @item = Items.find(params[:id])
  end
end
