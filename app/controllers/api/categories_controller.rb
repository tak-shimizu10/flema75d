
class Api::CategoriesController < ApplicationController
 
  def show

    if params[:id] == "0"
      @categories = Category.where(ancestry:nil)
    else
      @categories = Category.find(params[:id]).children
    end

    respond_to do |format|
      format.html{
        if params[:id] == "0"
          redirect_to category_all_items_path
        else
          redirect_to category_all_items_path(category_id: params[:id])
        end
      }
      format.json{
        render json: @categories
      }
    end 

  end

end
