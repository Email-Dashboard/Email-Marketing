class UserMailer < ApplicationMailer
  def campaign_email(_user, _subject, _content = '')
    @user    = _user
    @subject = _subject
    @content = _content
    mail_delivery_options(@user, @subject, @user.account)
  end

  private

  def mail_delivery_options(user, subject, _account)
    @mail_hash = { to: user.email, subject: subject, from: _account.mail_setting.from_email }

    delivery_options = {
      user_name: _account.mail_setting.user_name,
      password:  _account.mail_setting.password,
      address:   _account.mail_setting.address,
      port:      _account.mail_setting.port,
      domain:    _account.mail_setting.domain,
      enable_starttls_auto: true
    }
    @mail_hash[:delivery_method_options] = delivery_options
    mail @mail_hash
  end
end
