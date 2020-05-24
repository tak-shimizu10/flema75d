class Api::SelectsController < ApplicationController
  def index
    @children = Category.find(params[:category_id]).children
  end
end
