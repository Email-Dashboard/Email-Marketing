class UserMailer < ApplicationMailer
  def campaign_email(_user, _campaign, _subject, _content = '')
    @user    = _user
    @subject = _subject
    @content = _content
    category = "Campaign-#{_campaign.id}"
    send_email_with_delivery_options(@user, @subject, category)
  end
end
