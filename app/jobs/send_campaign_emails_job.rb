class SendCampaignEmailsJob < ApplicationJob
  rescue_from do
    retry_job queue: :high_priority
  end

  def perform(campaign_id)
    campaign = Campaign.find campaign_id

    campaign.users.each do |user|
      begin
        campaign_user = campaign.campaign_users.find_by(user_id: user.id)
        if campaign_user.draft?
          UserMailer.campaign_email(campaign_user).deliver_now
          campaign_user.update(sent_at: Time.now, status: :processed)
        end
      rescue => e
        Rails.logger.info("MAILER EXCEPTION: #{e} - ID: #{_user.id}")
      end
    end
  end
end
