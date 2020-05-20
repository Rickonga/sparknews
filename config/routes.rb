Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  resources :quotes, only: %i(index show)
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :stocks, only: %i[index show]
end
