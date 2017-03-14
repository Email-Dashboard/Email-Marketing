class SendCampaignEmailsJob < ApplicationJob
  rescue_from do
    retry_job queue: :high_priority
  end

  def perform(campaign_id)
    campaign = Campaign.find campaign_id

    campaign.users.each do |user|
      campaign_user = campaign.campaign_users.find_by(user_id: user.id)
      if campaign_user.status == 'draft'
        UserMailer.campaign_email(campaign_user).deliver_now
        campaign_user.update(sent_at: Time.now, status: 'processed')
      end
    end
  end
end
