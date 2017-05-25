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

    Mail.deliver do
      from     'sadik@mojilala.com'
      to       mail_to
      subject  subject
      body     mail_body
    end

    redirect_to users_path, notice: 'Message was successfully sent!'
  end

  private

  # To read emails
  def set_imap_settings
    Mail.defaults do
      retriever_method :imap,
                       :address    => 'outlook.office365.com',
                       :port       => 993,
                       :user_name  => 'sadik@mojilala.com',
                       :password   => 'H3qnkr83SLdt',
                       :enable_ssl => true
    end

    @emails = Mail.find(what: :last, count: 6, order: :desc)
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
