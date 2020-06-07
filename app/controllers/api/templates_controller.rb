class Api::TemplatesController < ApplicationController

  # ログインしてなければ、ログイン画面に映る
  before_action :authenticate_user!

  def top
    partial = render_to_string(partial: "templates/top")
    render json: { html: partial }
  end

  def logout
    partial = render_to_string(partial: "templates/logout")
    render json: { html: partial }
  end

  def mylike
    mylike_item_ids
    @like_items = Kaminari.paginate_array(@like_items).page(params[:page]).per(8)
  end

  def exhibition
    @myitems = Item.where(user_id: current_user.id).where(situation: 0)
    @exhibition_items = Kaminari.paginate_array(@myitems).page(params[:page]).per(8)
  end

  def purchased
    @purchaseditems = Item.where(buyer_id: current_user.id)
    @purchased_items = Kaminari.paginate_array(@purchaseditems).page(params[:page]).per(8)
  end
  private

  ##Likeテーブルからログインユーザーと一致するitem_idを取得して、昇順に
  ##→取得したitem_idsを一つずつItemテーブルから検索
  ##→検索結果を@like_itemsに配列として代入
  def mylike_item_ids
    @item_ids = Like.where(user_id: current_user.id).pluck(:item_id).sort!
    @like_items = []
    @item_ids.each do |id|
      item = Item.find(id.to_s)
      @like_items << item
    end
  end
end
