class InboxController < ApplicationController
  before_action :authenticate_account!
  before_action :set_imap_settings, only: [:index, :show]
  before_action :set_smtp_settings, only: :reply_email

  def index; end

  def show
    @email = @emails.select{ |email| email.message_id == params[:id] }.first
    @user = current_account.users.find_by(email: @email.from.first)
  end

  def reply_email
    subject   = params[:subject].upcase.start_with?('RE:') ? params[:subject] : "Re: #{params[:subject]}"
    mail_to   = params[:mail_to]
    mail_body = params[:body]
    mail_from = current_account.mail_setting.reply_to

    Mail.deliver do
      from     mail_from
      to       mail_to
      subject  subject
      body     mail_body
    end
  end

  private

  # To read emails
  def set_imap_settings
    settings = current_account.mail_setting

    if !settings.imap_address.present? || !settings.imap_port.present? || !settings.imap_password.present?
      redirect_to settings_path, notice: 'Please! Add your Reply Settings to read the messages.'
      return
    end

    Mail.defaults do
      retriever_method :imap,
                       :address    => settings.imap_address,
                       :port       => settings.imap_port,
                       :user_name  => settings.reply_to,
                       :password   => settings.imap_password,
                       :enable_ssl => true
    end

  # @emails = Mail.find(what: :last, count: 100, order: :desc)
    @emails = Mail.all
  end

  # To send email
  def set_smtp_settings
    settings = current_account.mail_setting

    Mail.defaults do
      delivery_method :smtp,
                      user_name: settings.user_name,
                      password:  settings.password,
                      address:   settings.address,
                      port:      settings.port,
                      domain:    settings.domain,
                      authentication: 'plain',
                      enable_starttls_auto: true
    end
  end
end
