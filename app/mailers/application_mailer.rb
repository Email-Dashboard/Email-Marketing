class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'

  def send_email_with_delivery_options(user, subject, category)

    delivery_options = {
        user_name: _account.mail_setting.user_name,
        password:  _account.mail_setting.password,
        address:   _account.mail_setting.address,
        port:      _account.mail_setting.port,
        domain:    _account.mail_setting.domain,
        authentication: 'plain',
        enable_starttls_auto: true
    }

    headers 'X-SMTPAPI' => { category: category.to_s }.to_json

    mail(
      to: user.email,
      subject: subject,
      from: user.account.mail_setting.try(:from_email),
      delivery_method_options: delivery_options
    )
  end
end
