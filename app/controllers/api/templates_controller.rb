class Api::TemplatesController < ApplicationController
  def top
    partial = render_to_string(partial: "templates/top")
    render json: { html: partial }
  end

  def logout
    partial = render_to_string(partial: "templates/logout")
    render json: { html: partial }
  end

  def mylike
    mylike_items
    partial = render_to_string(partial: "templates/mylike")
    render json: { html: partial }
    binding.pry
  end

  private

  def mylike_items
    @item_ids = Like.where(user_id: current_user.id).pluck(:item_id).sort!
    @like_items = []
    @item_ids.each do |id|
      item = Item.find_by(id.to_s)
      @like_items << item
    end
  end
end
