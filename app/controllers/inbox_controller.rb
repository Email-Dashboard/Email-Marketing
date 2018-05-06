class InboxController < ApplicationController
  require 'net/imap'
  before_action :set_imap_settings, only: :index
  before_action :set_message_uid, only: [:add_to_archive, :delete_message]

  def index
    if params[:from].present? && params[:to].present?
      date_from = Date.parse(params[:from]).strftime('%d-%b-%Y')
      date_to   = Date.parse(params[:to]).strftime('%d-%b-%Y')
      filter    = { count: :all, order: :desc, keys: ['SINCE', date_from, 'BEFORE', date_to] }
    else
      filter = { what: :last, count: 5, order: :desc }
    end

    begin
      @emails = Mail.find(filter)
    rescue => e
      @emails = []
      flash[:notice] = "IMAP: #{e}"
    end
  end

  def detail
    @message = params[:message]
    @subject = params[:subject]
    @email = params[:email]
    @has_attach = params[:has_attachments]
    @user = current_account.users.find_by(email: @email)
    @message_id = params[:message_id]

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

  def add_to_archive
    if @uid.present?
      @imap.create('Archive') unless @imap.list('', 'Archive')
      @imap.copy(@uid.try(:first), 'Archive')
      @imap.store(@uid.try(:first), "+FLAGS", [:Deleted])
    end
    @imap.expunge
    @imap.disconnect
  end

  def delete_message
    @imap.store(@uid.try(:first), "+FLAGS", [:Deleted]) if @uid.present?
    @imap.expunge
    @imap.disconnect
  end

  private
  # for adding to archive and delete
  def set_message_uid
    settings = current_account.imap_settings.find_by(id: params[:imap_id]) || current_account.imap_settings.first
    @message_id = params[:message_id]

    @imap = Net::IMAP.new(settings.address, settings.port, usessl: true, ssl: true)
    @imap.login(settings.email, settings.password)

    @imap.select("Inbox")
    @uid = @imap.search(["HEADER", "Message-ID", @message_id])
  end

  # To read emails
  def set_imap_settings
    settings = current_account.imap_settings.find_by(id: params[:imap_id]) || current_account.imap_settings.first

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
