Rails.application.routes.draw do

  devise_for :admin_users
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  devise_for :accounts

  authenticated :account do
    root 'users#index', as: :authenticated_root
  end

  root to: 'home#index'

  resources :users do
    collection do
      post 'create_single'
      get  'import'
      get 'detailed_list'
    end

    resources :user_attributes
  end

  resources :campaigns, except: [:edit, :update] do
    member do
      post 'send_emails'
    end

    collection do
      post :add_users
      post 'event_receiver'
    end
  end

  resources :smtp_settings do
    member do
      post :set_default_for_campaigns
      post :set_default_for_reply
    end
  end
  resources :imap_settings

  resources :email_templates

  resources :inbox do
    collection do
      post :add_to_archive
      post :reply_email
      post :detail
      post :delete_message
    end
  end

  resources :tags do
    collection do
      post 'remove_tag_from_item'
      post 'add_tag_to_item'
    end
  end

  resources :notes

  get 'tag_search', to: 'tags#tag_search'

  namespace :api do
    namespace :v1 do
      resources :users
    end
  end

  # config/routes.rb
  require "sidekiq/web"
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_USERNAME"])) &
      ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_PASSWORD"]))
  end if Rails.env.production?
  mount Sidekiq::Web, at: "/sidekiq"
end
