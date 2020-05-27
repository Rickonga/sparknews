Rails.application.routes.draw do
  get 'stock_watchlists/create'
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :stocks, only: %i[index] do
    resources :watchlists, only: %i[create]
    resources :stock_watchlists, only: %i[create]
    resources :user_watchlist_stocks, only: %i[create]
  end
  resources :watchlists, only: %i[create]
  resources :user_watchlist_stocks, only: [:destroy]
  resources :user_watchlists, only: [:destroy]

  resources :saved_tweets, only: [:index, :create, :destroy]
end
