module Webhooks
  class BaseController < ApplicationController
    skip_before_action :authenticate_account!
    skip_before_action :verify_authenticity_token
  end
end