Rails.application.routes.draw do
  devise_for :accounts
  root to: 'home#index'

  resources :users, only: [:index, :destroy]

  resources :campaigns, except: [:edit, :update] do
    member do
      post 'send_emails'
    end
  end
end
