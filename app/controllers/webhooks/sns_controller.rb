module Webhooks
  class SnsController < BaseController
    def create
      puts params.inspect

      Rails.logger.info params.inspect

      if request.headers["x-amz-sns-message-type"] == 'SubscriptionConfirmation'
        puts HTTParty.get(JSON.parse(env['rack.input'].read)['SubscribeURL'])
      end

      puts JSON.parse(env['rack.input'].read)

      head :ok, content_type: "text/plain"
    end
  end
end