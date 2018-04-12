class CreateCampaignJob < ApplicationJob
  queue_as :high_priority

  rescue_from do
    retry_job queue: :high_priority
  end

  def perform(args)
    current_account = Account.find args[:account_id]

    # Set Campaign Users from the query
    campaign_users = collect_query_users(args[:query], args[:query_from], current_account, args[:campaign_id])

    campaign_users = campaign_users.first(args[:limit].to_i) if args[:limit].present?

    campaign = current_account.campaigns.new(args[:campaign_params])
    campaign.users = campaign_users
    campaign.tag_list.add args[:tags]

    campaign.save!
  end

  def collect_query_users(query, query_from, account, campaign_id)
    query_hash = Rack::Utils.parse_nested_query(query) # convert string params to hash

    if query_from == 'campaign'
      campaign = account.campaigns.find campaign_id
      if query == 'all'
        campaign.users
      else
        q = campaign.campaign_users.ransack(query_hash)
        cu = q.result(distinct: true).to_a
        campaign.users.where(id: cu.pluck(:user_id))
      end
    else
      if query == 'all'
        account.users
      else
        q = account.users.ransack(query_hash)
        q.result(distinct: true)
      end
    end
  end
end
