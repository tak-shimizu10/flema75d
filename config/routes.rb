Rails.application.routes.draw do

  root "items#index"
  devise_for :users, controllers: {
                       registrations: "users/registrations",
                     }
  devise_scope :user do
    get "addresses", to: "users/registrations#new_address"
    post "addresses", to: "users/registrations#create_address"
  end

  resources :users, only: [:show]

  # 購入確認ページに飛ぶ
  resources :items do
    resources :buys, only: [:new,:create]
  end

  # カテゴリ機能に使用
  namespace :api do
    resources :selects, only: [:index]
    resources :cards, only: [:index,:new,:create,:destroy]
    resource :templates, only: [] do
      member do
        get 'logout'
      end
    end
  end

  resources :categories, only: [:show]

end

