Rails.application.routes.draw do
  devise_for :accounts
  root to: 'home#index'

  resources :users, only: [:index, :destroy]
end
