class AddUsersToCampaignJob < ApplicationJob
  rescue_from do
    retry_job queue: :high_priority
  end

  def perform(campaign_id, _filter)
    campaign = Campaign.find campaign_id

    campaign.account.users.ransack(_filter).result(distinct: true).each do |user|
      begin
        campaign.campaign_users.create(user_id: user.id)
      rescue => ex
        Rails.logger.info ex
      end
    end
  end
end
