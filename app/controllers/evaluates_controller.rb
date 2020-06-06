class EvaluatesController < ApplicationController
  before_action :set_item, only: [:new, :create, :destroy]

  def new
    @item = Item.find(params[:item_id])
    if @item.user[:id] != current_user.id && @item.evaluates.blank? && @item.buyer_id == current_user.id
      @evaluate = Evaluate.new
    else
      redirect_to user_path(current_user.id)
    end
  end

  def create
    if @item.user[:id] != current_user.id && @item.evaluates.blank?
      evaluate = @item.evaluates.build(evaluate_params)
      evaluate.user_id = @item.user[:id]
      if evaluate.save!
        redirect_to root_path
      else
        set_item
        render :new
      end
    else
      redirect_to root_path
    end
  end

  def destory
    @item.evaluates.destroy
  end

  private

  def evaluate_params
    params.require(:evaluate)
          .permit(:rate, :comment, :user_id)
          .merge(item_id: params[:item_id], evaluate_user_id: current_user.id)
  end

  def set_item
    @item = Item.find(params[:item_id])
  end
end
