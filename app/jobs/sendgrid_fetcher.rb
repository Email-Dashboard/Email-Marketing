class SendgridFetcher < ApplicationJob

  def fetch_campaign(campaign_id)
    campaign = Campaign.find campaign_id
  end
end