Rails.application.routes.draw do
  devise_for :accounts

  authenticated :account do
    root 'users#index', as: :authenticated_root
  end

  root to: 'home#index'

  resources :users, only: [:index, :destroy, :new, :create]

  resources :campaigns, except: [:edit, :update] do
    member do
      post 'send_emails'
    end

    collection do
      post 'event_receiver'
    end
  end

  resources :email_templates

  get 'settings', to: 'home#settings'
  post 'update_settings', to: 'home#update_settings'


  # config/routes.rb
  require "sidekiq/web"
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_USERNAME"])) &
      ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_PASSWORD"]))
  end if Rails.env.production?
  mount Sidekiq::Web, at: "/sidekiq"
end
