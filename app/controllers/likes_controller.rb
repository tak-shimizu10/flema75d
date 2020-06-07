class LikesController < ApplicationController

  # ログインしてなければ、ログイン画面に映る
  before_action :authenticate_user!

  def create
    @item = Item.find(params[:item_id])
    like = current_user.likes.build(item_id: params[:item_id])
    like.save
  end

  def destroy
    @item = Item.find(params[:item_id])
    like = Like.find_by(item_id: params[:item_id], user_id: current_user.id)
    like.destroy
  end
end
