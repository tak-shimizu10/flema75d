class Items::BuysController < ApplicationController

  # payjpに関連するエラーが発生した際に例外処理を行う
  rescue_from  Payjp::PayjpError, with: :payjp_error
  rescue_from  Payjp::APIError, with: :payjp_error
  rescue_from  Payjp::APIConnectionError, with: :payjp_error
  rescue_from  Payjp::AuthenticationError, with: :payjp_error
  rescue_from  Payjp::InvalidRequestError, with: :payjp_error
  rescue_from  Payjp::CardError, with: :payjp_error
 
  # 商品の購入確認
  def new
  end

  # 商品の購入
  def create
    
    require 'payjp'
    Payjp.api_key = Rails.application.credentials.dig(:payjp, :PAYJP_SECRET_KEY)

    Payjp::Charge.create(
      amount: 5000,
      customer: current_user.cards.first[:customer_id],
      currency: 'jpy'
    )

    # 出品中（0）を取引中（1）に変更
    item = Item.find(params[:id])
    item.situation = 1
    item.save

  end

  private

  def payjp_error(event)
    @error = event.json_body[:error]
    if params[:action] == "create"
      render "new"
    elsif params[:action] == "update"
      render "edit"
    else
      # 削除画面に戻る
    end
  end

end
