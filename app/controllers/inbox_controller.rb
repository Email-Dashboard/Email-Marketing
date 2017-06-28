class InboxController < ApplicationController
  before_action :authenticate_account!
  before_action :set_imap_settings, only: [:index, :reply_email]

  def index
    if params[:from].present? && params[:to].present?
      date_from = Date.parse(params[:from]).strftime('%d-%b-%Y')
      date_to   = Date.parse(params[:to]).strftime('%d-%b-%Y')
      @emails = Mail.find(count: :all, order: :desc, keys: ['SINCE', date_from, 'BEFORE', date_to])
    else
      @emails = Mail.find(what: :last, count: 5, order: :desc)
    end
  end

  def detail
    @message = params[:message]
    @subject = params[:subject]
    @email = params[:email]
    @user = current_account.users.find_by(email: @email)

    if @user.present?
      if params[:cu_id].present?
        @campaign_users = @user.campaign_users.where(id: params[:cu_id])
      else
        templates = current_account.email_templates.where(subject: @subject.remove('Re: '))
        campaigns = @user.campaigns.where(email_template_id: templates.try(:ids))
        @campaign_users = @user.campaign_users.where(campaign_id: campaigns.try(:ids))
      end
    end
  end

  def reply_email
    subject   = params[:subject].upcase.start_with?('RE:') ? params[:subject] : "Re: #{params[:subject]}"
    mail_to   = params[:mail_to]
    mail_body = Tilt::ERBTemplate.new { params[:body] }
    content   = mail_body.render(current_account.users.find_by(email: params[:mail_to]))
    mail_from = current_account.mail_setting.imap_username

    Mail.deliver do
      from     mail_from
      to       mail_to
      subject  subject
      html_part do
        content_type 'text/html; charset=UTF-8'
        body content
      end
    end
  end

  private

  # To read emails
  def set_imap_settings
    settings = current_account.mail_setting

    if !settings.imap_address.present? || !settings.imap_port.present? || !settings.imap_password.present? || !settings.imap_username.present?
      redirect_to settings_path, notice: 'Please! Add your IMAP Settings to read the messages.'
      return
    end

    Mail.defaults do
      retriever_method :imap,
                       :address    => settings.imap_address,
                       :port       => settings.imap_port,
                       :user_name  => settings.imap_username,
                       :password   => settings.imap_password,
                       :enable_ssl => true
    end
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
