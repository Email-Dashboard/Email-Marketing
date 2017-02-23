Rails.application.routes.draw do
  devise_for :accounts
  root to: 'home#index'

  resources :users, only: [:index, :destroy]

  resources :campaigns, except: [:edit, :update] do
    member do
      post 'send_emails'
    end
  end

  get 'settings', to: 'home#settings'
  post 'update_settings', to: 'home#update_settings'
end
