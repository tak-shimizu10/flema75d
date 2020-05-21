Rails.application.routes.draw do
  
  root 'items#index'
  
  # 購入確認ページに飛ぶ
  namespace :items do 
    resources :buys, only: [:index]
  end

end
