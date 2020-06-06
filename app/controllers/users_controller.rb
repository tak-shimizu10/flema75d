class UsersController < ApplicationController
  def show
    @categories = Category.where(ancestry: nil)
    @user = User.find(params[:id])
  end
end
