Rails.application.routes.draw do
  resources :categories
  devise_for :users, :controllers => {
    :sessions      => "users/sessions",
    :registrations => "users/registrations",
    :passwords     => "users/passwords",
  }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "welcome#index"

  resources :products do
    member do
      post :add_to_cart
      post :favourite
      post :unfavourite
    end
    collection do
      get :search
    end
    resources :comments
  end

  resources :carts do
    collection do
      delete :clean
      post :checkout
    end
  end

  resources :orders do
    member do
      post :pay_with_alipay
      post :pay_with_wechat
      post :apply_to_cancel
      post :apply_to_return_good
      post :confirm_shipped
    end
  end

  resources :cart_items

  namespace :admin do
    resources :products do
      member do
        post :move_up
        post :move_down
        post :shelve
        post :off_shelve
      end
    end

    resources :orders do
      member do
      post :cancel
      post :ship
      post :shipped
      post :return
    end
    end
  end

  namespace :account do
    resources :orders
    resources :users
  end



end
