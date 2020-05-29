class CategoriesController < ApplicationController
  def show
    @categories = Category.where(ancestry:nil)
    @category = Category.find(params[:id])
  end
end
