Rails.application.routes.draw do

  root "items#index"
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: "users/registrations"
  }
  devise_scope :user do
    get "addresses", to: "users/registrations#new_address"
    post "addresses", to: "users/registrations#create_address"
  end

  resources :users, only: [:new, :show]

  # 購入確認ページに飛ぶ
  resources :items do
    resources :buys, only: [:new, :create]
    resources :comments, only: [:create]
  end

  # カテゴリ機能に使用
  namespace :api do
    resources :selects, only: [:index]
    resources :cards, only: [:index, :new, :create, :destroy]
    resource :templates, only: [] do
      member do
        get 'top'
        get 'logout'
      end
    end
  end

  resource :all_items, only: [:index] do
    member do
      get 'category'
    end
  end

  resources :all_items, only: [:index]

end