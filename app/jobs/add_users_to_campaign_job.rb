class AddUsersToCampaignJob < ApplicationJob
  rescue_from do
    retry_job queue: :high_priority
  end

  def perform(account_id, campaign_id, filter, limit)
    account = Account.find account_id
    campaign = account.campaigns.find campaign_id

    account.users.ransack(filter).result(distinct: true).limit(limit).each do |user|
      begin
        campaign.campaign_users.create(user_id: user.id)
      rescue => ex
        Rails.logger.info ex
      end
    end
  end
end
