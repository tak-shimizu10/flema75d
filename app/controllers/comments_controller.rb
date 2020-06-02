class CommentsController < ApplicationController

  rescue_from ActiveRecord::RecordInvalid , with: :comment_error_check
  
  def create
    comment = Comment.new(comment_params)
    comment.save!
    redirect_to item_path(params[:item_id])
  end

  private
  def comment_params
    params.require(:comment).permit(:comment).merge( item_id:params[:item_id], user_id:current_user.id)
  end

  def comment_error_check(event)
    redirect_to item_path(params[:item_id]), notice: event.message
  end

end