class EvaluatesController < ApplicationController
  def new
    @item = Item.find(params[:item_id])
    @evaluate = Evaluate.new
  end

  def create
    @item = Item.find(params[:item_id])
    evaluate = current_user.evaluates.build(evaluate_params)
    evaluate.save!
    redirect_to root_path
  end

  def destory
  end

  private

  def evaluate_params
    params.require(:evaluate)
          .permit(:rate, :comment)
          .merge(user_id: current_user.id, item_id: params[:item_id])
  end
end
