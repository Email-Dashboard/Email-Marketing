class Api::V1::ApiBaseController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_filter :authenticate

  protected
  def authenticate
    authenticate_or_request_with_http_token do |token, _options|
      @api_account = Account.find_by(authentication_token: token)
    end
  end
end
