class HomeController < ApplicationController
  before_action :authenticate_account!, only: :settings
  def index; end

  def settings
    @settings = current_account.mail_setting
  end

  def update_settings
    if current_account.mail_setting.update(settings_params)
      redirect_to settings_path, notice: 'Settings updated successfully!'
    else
      redirect_to settings_path, notice: 'Error! Settings not updated!'
    end
  end

  private

  def settings_params
    params.require(:settings).permit(:from_email, :reply_to, :address, :port, :domain, :user_name, :password, :provider,
                                 :imap_password, :imap_port, :imap_address, :imap_username)
  end
end
