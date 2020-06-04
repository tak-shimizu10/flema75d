class UsersController < ApplicationController
  
  def show
    @categories = Category.where(ancestry: nil)
  end
end
