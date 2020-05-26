Rails.application.routes.draw do

  root "items#index"
  devise_for :users, controllers: {
            registrations: "users/registrations",
          }
  devise_scope :user do
    get "addresses", to: "users/registrations#new_address"
    post "addresses", to: "users/registrations#create_address"
  end
  namespace :items do
    resources :buys, only: [:new,:create]
  end
  resources :items, only: [:index, :new]

 # namespace :api do
 #   resources :selects,only: [:index]
 #   resources :cards,only: [:new,:create, :destroy]
 # end

  resources :accounts, only:[:index,:edit,:show] do
    get 'logout'
  end
end

