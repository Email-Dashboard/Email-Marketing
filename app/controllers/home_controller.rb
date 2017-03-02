class HomeController < ApplicationController
  before_action :authenticate_account!, only: :settings
  def index; end

  def settings
    @settings = current_account.mail_setting
  end

  def update_settings
    if current_account.mail_setting.update(smtp_params)
      redirect_to settings_path, notice: 'Settings updated successfully!'
    else
      redirect_to settings_path, notice: 'Error! Settings not updated!'
    end
  end

  private

  def smtp_params
    params.require(:smtp).permit(:from_email, :address, :port, :domain, :user_name, :password, :provider)
  end
end
