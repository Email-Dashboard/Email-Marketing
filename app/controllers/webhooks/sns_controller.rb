module Webhooks
  class SnsController < BaseController
    def create
      if request.headers['x-amz-sns-message-type'] == 'SubscriptionConfirmation'
        HTTParty.get(JSON.parse(env['rack.input'].read)['SubscribeURL'])
        head :ok, content_type: 'text/plain'

        return
      end

      data = JSON.parse(env['rack.input'].read)

      message = JSON.parse(data['Message'])

      uniq_header = message['mail']['headers'].select{ |obj| obj['name'] == 'X-SMTPAPI' }.first

      uniq_header = JSON.parse(uniq_header['value'])

      uniq_id = uniq_header['unique_args']['campaign_user_id']

      campaign_user = CampaignUser.find(uniq_id)

      campaign_user.update(status: message['eventType'])

      head :ok, content_type: 'text/plain'
    end
  end
end