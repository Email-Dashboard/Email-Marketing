class UserMailer < ApplicationMailer
  def campaign_email(_user, _subject, _content = '')
    @user    = _user
    @subject = _subject
    @content = _content
    mail_delivery_options(@user, @subject)
  end

  private

  def mail_delivery_options(user, subject)
    mail(to: user.email, subject: subject, from: 'sadik@test.com') # user.account.from_email
  end
end
