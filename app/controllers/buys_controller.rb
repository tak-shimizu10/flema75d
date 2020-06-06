class BuysController < ApplicationController

  # 商品情報を取得
  before_action :find_buys_info, only: [:new, :create]

  # payjpを使用するための認証を行う
  before_action :payjp_sertification, only: [:new, :create]

  # payjpに関連するエラーが発生した際に例外処理を行う
  rescue_from Payjp::PayjpError, with: :payjp_error
  rescue_from Payjp::APIError, with: :payjp_error
  rescue_from Payjp::APIConnectionError, with: :payjp_error
  rescue_from Payjp::AuthenticationError, with: :payjp_error
  rescue_from Payjp::InvalidRequestError, with: :payjp_error
  rescue_from Payjp::CardError, with: :payjp_error

  # 商品の購入確認
  def new
    if @item.situation == "exhibition"
      @address = current_user.address
      unless @user_cards.blank?
        @customer_id = @user_cards.first[:customer_id]
        customer = Payjp::Customer.retrieve(@customer_id)
        @card_data = customer.cards.retrieve(customer.default_card)
      end
    else
      redirect_to root_path
    end
  end

  # 商品の購入
  def create
    if @item.user[:id] != current_user.id
      @customer_id = @user_cards.first[:customer_id]

      Payjp::Charge.create(
        amount: @item[:price],
        customer: @customer_id,
        currency: "jpy",
      )

      # 出品中（0）を取引中（1）に変更
      @item.situation_transaction!
      @item.buyer_id = current_user.id
      if @item.save
        redirect_to root_path
      else
        redirect_to new_item_buy_path(@item)
      end
    else
      redirect_to root_path
    end
  end

  private

  def find_buys_info
    @item = Item.find(params[:item_id])
    @user_cards = current_user.cards
  end

  def payjp_sertification
    require "payjp"
    Payjp.api_key = Rails.application.credentials.dig(:payjp, :PAYJP_SECRET_KEY)
  end

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
