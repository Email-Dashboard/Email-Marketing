class CreateCampaignJob < ApplicationJob
  queue_as :high_priority

  rescue_from do
    retry_job queue: :high_priority
  end

  def perform(query, campaign_params, account_id)

    current_account = Account.find account_id

    # Set Campaign Users from the query
    @campaign_users = if query == 'all'
                        current_account.users.all
                      else
                        query = Rack::Utils.parse_nested_query(query) # convert string params to hash
                        q = current_account.users.ransack(query)
                        q.result(distinct: true)
                      end


    @campaign = current_account.campaigns.new(campaign_params)
    @campaign.users = @campaign_users
    @campaign.email_template_id = nil if campaign_params[:email_template_id] == 'new_template'
  end
end