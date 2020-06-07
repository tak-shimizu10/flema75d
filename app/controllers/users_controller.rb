class UsersController < ApplicationController
  
  # ログインしてなければ、ログイン画面に映る
  before_action :authenticate_user!,only: [:show]

  def new
  end

  def show
    @categories = Category.where(ancestry: nil)
    @user = User.find(params[:id])
  end
end
