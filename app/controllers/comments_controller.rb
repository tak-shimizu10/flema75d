class CommentsController < ApplicationController

  def create
    comment = Comment.new(comment_params)
    if comment.save
      redirect_to item_path(params[:item_id])  
    else
      # @categories = Category.where(ancestry: nil)
      # @item = Item.find(params[:item_id])
      # @items = @item.user.items
      # @comment = Comment.new
      # render template: "items/show"
    end
end

  private
  def comment_params
    params.require(:comment).permit(:comment).merge( item_id:params[:item_id], user_id:current_user.id)
  end

end
