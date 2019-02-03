class OrganizationSubdomain
  def self.matches? request
    case request.subdomain
    when 'www'
      false
    when ''
      false
    else
      true
    end
  end
end

Rails.application.routes.draw do
  devise_for :users

  root to: 'pages#index'

  resources :organizations

  constraints(OrganizationSubdomain) do
    root to: 'contacts#index'
    resources :contacts
  end
end