class Api::CardsController < ApplicationController

  # ログインしてなければ、ログイン画面に映る
  before_action :authenticate_user!

  # payjpを使用するための認証を行う
  before_action :payjp_sertification , only:[:index,:create,:destroy]

  # payjpに関連するエラーが発生した際に例外処理を行う
  rescue_from  Payjp::PayjpError, with: :payjp_error
  rescue_from  Payjp::APIError, with: :payjp_error
  rescue_from  Payjp::APIConnectionError, with: :payjp_error
  rescue_from  Payjp::AuthenticationError, with: :payjp_error
  rescue_from  Payjp::InvalidRequestError, with: :payjp_error
  rescue_from  Payjp::CardError, with: :payjp_error

  def index
    @categories = Category.where(ancestry: nil)
    @user_cards = current_user.cards
    unless @user_cards.blank?
      customer_id = @user_cards.first[:customer_id]
      @customer = Payjp::Customer.retrieve(customer_id)
    end
    partial = render_to_string(cards: "index.html.haml", locals: { categories: @categories, user_cards: @user_cards,customer: @customer })
    render json:{html:partial}
  end

  def new   

  end

  def create

    # paramsから入力された値を取得し、変数に代入
    card_info = card_params
   
    # 西暦を4桁にしないとエラーが発生するので修正
    card_info[:"exp_date(1i)"] = "20" + card_info[:"exp_date(1i)"]

    # 送信した際にカード情報が漏れないよう、トークンを作成 
    token = Payjp::Token.create({
      card: {
        number:     card_info[:"card_id"],  
        cvc:        card_info[:"cvc"],
        exp_year:   card_info[:"exp_date(1i)"],    
        exp_month:  card_info[:"exp_date(2i)"]
      }},
      {'X-Payjp-Direct-Token-Generate': 'true'} 
    )

    # トークンidは使い捨てであるため、代用で顧客idを使用
    # payjpにカード情報を登録（新規登録かカードの追加で条件分岐）
    user_card = Card.find_by( user_id: card_info[:user_id] )
    if user_card.nil?
      customer = Payjp::Customer.create(card: token)
      card_id = customer.default_card
    else
      customer = Payjp::Customer.retrieve(user_card[:customer_id])
      card = customer.cards.create(card: token)
      card_id = card.id
    end

    # データーベース上にpayjp上のカード情報を読み取るためのデータを保存
    card = Card.new( customer_id: customer.id, card_id: card_id, user_id: card_info[:user_id])
    unless card.save
      render "new"
    end
  
  end

  # 登録されたカードの削除を行う
  def destroy

    card_info = Card.find(params[:id])
    customer = Payjp::Customer.retrieve(card_info[:customer_id])
    card = customer.cards.retrieve(card_info[:card_id])

    # payjp上とデータベースのカード情報を削除する
    card.delete
    card_info.destroy

  end

  private

  def payjp_sertification   
    require 'payjp'
    Payjp.api_key = Rails.application.credentials.dig(:payjp, :PAYJP_SECRET_KEY)
  end

  def card_params
    params.permit(:card_id,:cvc,:exp_date).merge(user_id:current_user.id)
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
