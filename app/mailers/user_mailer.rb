class UserMailer < ApplicationMailer
  def campaign_email(campaign_user)
    @user    = campaign_user.user
    @subject = campaign_user.campaign.email_template.try(:subject)
    @content = campaign_user.campaign.email_template.try(:body)
    send_email_with_delivery_options(campaign_user, @subject)
  end
end
