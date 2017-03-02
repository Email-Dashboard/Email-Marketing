class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'

  def send_email_with_delivery_options(campaign_user, subject)

    settings = campaign_user.user.account.mail_setting

    delivery_options = {
        user_name: settings.user_name,
        password:  settings.password,
        address:   settings.address,
        port:      settings.port,
        domain:    settings.domain,
        authentication: 'plain',
        enable_starttls_auto: true
    }

    # Set unique args at header
    headers 'X-SMTPAPI' => { unique_args: { campaign_user_id: campaign_user.id } }.to_json

    mail(
      to: campaign_user.user.email,
      subject: subject,
      from: settings.try(:from_email),
      delivery_method_options: delivery_options
    )
  end
end
