class SendCampaignEmailsJob < ApplicationJob
  # No retry

  def perform(campaign_id)
    campaign = Campaign.find campaign_id

    campaign.campaign_users.where(status: 'draft').each do |campaign_user|
      begin
        UserMailer.campaign_email(campaign_user).deliver_now
        campaign_user.update(sent_at: Time.now, status: 'processed')
      rescue => ex
        Rails.logger.info ex
      end
    end
  end
end
