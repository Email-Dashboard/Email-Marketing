class UserMailer < ApplicationMailer
  def campaign_email(campaign_user, _subject, _content = '')
    @user    = campaign_user.user
    @subject = _subject
    @content = _content
    send_email_with_delivery_options(campaign_user, @subject)
  end
end
