class HomeController < ApplicationController
  layout 'welcome'
  skip_before_action :authenticate_account!

  def index; end

  def documentation; end
end
