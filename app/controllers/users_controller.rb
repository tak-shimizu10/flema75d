class UsersController < ApplicationController
  
  # ログインしてなければ、ログイン画面に映る
  before_action :authenticate_user!,only: [:show]

  def new
  end

  def show
    @categories = Category.where(ancestry: nil)
    @item = Item.where(user_id: current_user.id)
  end
end
