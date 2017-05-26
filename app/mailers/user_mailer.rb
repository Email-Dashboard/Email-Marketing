class UserMailer < ApplicationMailer
  def campaign_email(campaign_user)
    @campaign_user = campaign_user
    @user    = campaign_user.user

    template = campaign_user.campaign.email_template

    body = Tilt::ERBTemplate.new { "#{template.body}" }
    subject = Tilt::ERBTemplate.new { "#{template.subject}" }

    @subject = subject.render(@user)
    @content = body.render(@user)

    send_email_with_delivery_options(campaign_user, @subject)
  end
end
