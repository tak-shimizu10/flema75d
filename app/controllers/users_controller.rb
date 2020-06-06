class UsersController < ApplicationController
  def show
    @categories = Category.where(ancestry: nil)
    @item = Item.where(user_id: current_user.id)
  end
end
