class InboxController < ApplicationController
  before_action :authenticate_account!
  before_action :set_imap_settings, only: :index

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
    smtp_id   = current_account.smtp_settings.find_by(id: params[:smtp_id]).try(:id) ||
                current_account.smtp_settings.where(is_default_for_campaigns: true).first.try(:id)

    UserMailer.reply_email(mail_to, subject, content, smtp_id).deliver_now
  end

  private

  # To read emails
  def set_imap_settings
    settings = current_account.imap_settings.first

    if !settings.present? || !settings.address.present? || !settings.port.present? || !settings.password.present? || !settings.email.present?
      redirect_to imap_settings_path, notice: 'Please! Add your IMAP Settings to read the messages.'
      return
    end

    Mail.defaults do
      retriever_method :imap,
                       :address    => settings.address,
                       :port       => settings.port,
                       :user_name  => settings.email,
                       :password   => settings.password,
                       :enable_ssl => true
    end
  end
end
