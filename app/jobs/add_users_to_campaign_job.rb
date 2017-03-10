class AddUsersToCampaignJob < ApplicationJob
  rescue_from do
    retry_job queue: :high_priority
  end

  def perform(_account_id, campaign_id, _filter, _limit)
    account = Account.find _account_id
    campaign = account.campaigns.find campaign_id

    account.users.ransack(_filter).result(distinct: true).limit(_limit).each do |user|
      begin
        campaign.campaign_users.create(user_id: user.id)
      rescue => ex
        Rails.logger.info ex
      end
    end
  end
end
